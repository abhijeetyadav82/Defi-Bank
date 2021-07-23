pragma solidity >=0.7.0 <0.9.0;
import './Token.sol';
contract DBank is Token {
    
    Token private token;
    
    mapping(address => bool) isDeposited;
    mapping(address => bool) isBorrowed;
    mapping(address => uint) depositStart;
    mapping(address => uint) etherBalanceOf;
    mapping(address => uint) collateralEther;
    
    constructor(Token _token)  public{
        token = _token;
    }
    
    function deposit() payable public {
        
        require(!isDeposited[msg.sender],"Already Deposited");
        require(msg.value>=1e16, 'Error, deposit must be >= 0.01 ETH');

        
        etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;
        depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;
    
        isDeposited[msg.sender] = true;
    }
    
    function withdraw() payable public {
        require(isDeposited[msg.sender],"Deposite the amount first");
        
        uint userBalance = etherBalanceOf[msg.sender];
        uint depositTime = block.timestamp - depositStart[msg.sender];
        
        uint interestPerSec = 31668017 * (etherBalanceOf[msg.sender] / 1e16);
        uint interest = interestPerSec * depositTime;
        
        payable(msg.sender).transfer(etherBalanceOf[msg.sender]);
        token.mint(msg.sender, interest);
        
        
        depositStart[msg.sender] = 0;
        etherBalanceOf[msg.sender] = 0;
        isDeposited[msg.sender] = false;        
        
    }
    
    function borrow() payable public{
        require(!isBorrowed[msg.sender],"Loan already taken");
        require(msg.value >= 1e16, "Error, collateral must be >= 0.01ETH");
        
        collateralEther[msg.sender] = collateralEther[msg.sender] + msg.value;
        uint tokensToMint = collateralEther[msg.sender]/2;
        
        token.mint(msg.sender, tokensToMint);
        
        isBorrowed[msg.sender] = true;
    }
    
    function payOff() public {
        require(isBorrowed[msg.sender], "Error, loan not active");
        require(token.transferFrom(msg.sender, address(this), collateralEther[msg.sender]/2), "Error, can't receive tokens");
        
        uint fee = collateralEther[msg.sender]/10;
        
        payable(msg.sender).transfer(collateralEther[msg.sender] - fee);
        
        collateralEther[msg.sender] = 0;
        isBorrowed[msg.sender] = false;
    }
}