import React, { Component } from 'react';
import './App.css';
import web3 from './web3';
import token from './token';
import dbank from './dbank';

class App extends Component {
  state = {
    accounts: [],
    balance: '',
    value: '0',
    message: ''
  };

  async componentDidMount() {
    const balance = await web3.eth.getBalance(dbank.options.address);
    const accounts = await web3.eth.getAccounts();
    this.setState({accounts:accounts});
    this.setState({balance:balance});
    console.log(this.state.balance);
  }

  onDeposit = async event => {
    event.preventDefault();
    //const accounts = await web3.eth.getAccounts();
    await dbank.methods.deposit().send({
      from: this.state.accounts[0],
      value: web3.utils.toWei(this.state.value, 'ether')
    });

    this.setState({ message: 'You have been entered!' });
  };

  onWithdraw = async event => {
    event.preventDefault();
    //const accounts = await web3.eth.getAccounts();
    await dbank.methods.withdraw().send({
      from: this.state.accounts[0]
    });
  }


  render() {
    return (
      <div>
        <h2>DBank Contract</h2>


        <hr />
        <form onSubmit = {this.onDeposit}>
          <h4>Deposit your Ether to get interest.</h4>
          <div>
            <label>Amount of ether to enter</label>
            <input
              value={this.state.value}
              onChange={event => this.setState({ value: event.target.value })}
            />
          </div>
          <button>Deposit</button>
        </form>
        <hr />
        

        <hr />
        <form onSubmit = {this.onWithdraw}>
          <h4>Withdraw your ether here.</h4>
          <button>Withdraw</button>
        </form>
        <hr />


      </div>
    );
  }
}

export default App;