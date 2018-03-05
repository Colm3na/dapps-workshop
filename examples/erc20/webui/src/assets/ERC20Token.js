const contract = require('../../static/BasicToken');

export default class ERC20Token {
  constructor(web3, address, account) {
    this.contract = new web3.eth.Contract(contract.abi, address);
    this.account = account;
  }

  price() {
    return this.contract.methods.price().call();
  }

  totalSupply() {
    return this.contract.methods.totalSupply().call();
  }

  balanceOf(who) {
    return this.contract.methods.balanceOf(who).call();
  }

  transfer(to, value) {
    this.contract.methods.transfer(to, value).send({ from: this.account });
  }

  async buy(amount) {
    const price = await this.price();
    const value = price * amount;
    this.contract.methods.buy().send({ from: this.account, value });
  }
}
