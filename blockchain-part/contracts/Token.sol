pragma solidity >=0.7.0 <0.9.0;
import "../openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
contract Token is ERC20 {
    
    address public minter;
    
    constructor() public payable ERC20("CryptoBank Currency", "CRC"){
        minter = msg.sender;
    }
    
    function passMinterRole(address dBank) public returns(bool) {
        require(msg.sender == minter, "Error, the sender does not have a minter role");
        minter = dBank;
        return true;
    }
    
    function mint(address account, uint amount) public{
        require(msg.sender == minter , "Error, the sender does not have a minter role");
        _mint(account, amount);
    }
}
