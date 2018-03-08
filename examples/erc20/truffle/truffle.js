const Wallet = require('ethereumjs-wallet');
const WalletProvider = require('truffle-wallet-provider');
const Web3 = require('web3');

const PRIVATE_KEY = '';
const NODE_URL = 'https://ropsten.infura.io/';

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*'
    }
    // test: {
    //   provider: new WalletProvider(
    //     Wallet.fromPrivateKey(Buffer.from(PRIVATE_KEY, 'hex')),
    //     NODE_URL
    //   ),
    //   gas: 4600000,
    //   gasPrice: Web3.utils.toWei('20', 'gwei'),
    //   network_id: '3'
    // }
  }
};
