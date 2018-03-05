<template>
<div class="container">

  <section class="hero is-bold is-primary">
    <div class="hero-body">
      <nav class="level">
        <div class="level-item has-text-centered">
          <div>
            <p class="heading">Total Supply</p>
            <p class="title">{{ totalSupply }}</p>
          </div>
        </div>
        <div class="level-item has-text-centered">
          <div>
            <p class="heading">Price</p>
            <p class="title">{{ price }} Ξ</p>
          </div>
        </div>
      </nav>

      <div class="container has-text-centered">
        <h1 class="title">
          ERC20 Token Example
        </h1>
      </div>
    </div>
  </section>

  <div class="columns">
    <div class="column">
      <section class="section">
        <div class="container is-fluid">
          <h1 class="title">Balance</h1>
          <h2 class="subtitle"> Current balance: {{ balance }} tokens </h2>
          <div class="field">
            <div class="control">
              <input v-model="address"
                class="input"
                type="text"
                placeholder="Account">
            </div>
          </div>
          <div class="field">
            <div class="control">
              <button @click="checkBalance"
                class="button is-link">Check</button>
            </div>
          </div>
        </div>
      </section>
    </div>

    <div class="column">
      <section class="section">
        <div class="container is-fluid">
          <h1 class="title">Send</h1>
          <h2 class="subtitle"> Send tokens to another account </h2>
          <div class="field">
            <div class="control">
              <input v-model="transfer.to"
                class="input"
                type="text"
                placeholder="Account">
            </div>
          </div>
          <div class="field">
            <div class="control">
              <input v-model="transfer.value"
                class="input"
                type="text"
                placeholder="Amount">
            </div>
          </div>
          <div class="field">
            <div class="control">
              <button @click="transferToken"
                class="button is-link">Send Tokens</button>
            </div>
          </div>
        </div>
      </section>
    </div>

    <div class="column">
      <section class="section">
        <div class="container is-fluid">
          <h1 class="title">Buy</h1>
          <h2 class="subtitle"> Buy brand new tokens </h2>
          <div class="field">
            <div class="control">
              <input v-model="buyAmount"
                class="input"
                type="text"
                placeholder="Amount">
            </div>
          </div>
          <div class="field">
            <div class="control">
              <button @click="buy"
                class="button is-link">Buy Tokens</button>
            </div>
          </div>
        </div>
      </section>
    </div>
  </div>

  <footer class="footer">
    <div class="container">
      <div class="content has-text-centered">
        <p>
          <strong>Contract</strong> at <a :href="`http://ropsten.etherscan.io/address/${contractAddress}`">{{ contractAddress }}</a>.
        </p>
      </div>
    </div>
  </footer>
</div>
</template>

<script>
import Web3 from 'web3';
import ERC20Token from '../assets/ERC20Token';

export default {
  name: 'ERC20Token',

  data() {
    return {
      contractAddress: '0x2af2d96417ce297d60dff9d4552b1cbfa98c6bbc',
      token: null,
      totalSupply: 0,
      price: 0,
      balance: 0,
      address: '',
      transfer: {
        to: '',
        value: '',
      },
      buyAmount: '',
    };
  },

  async mounted() {
    const web3 = new Web3(window.web3.currentProvider);
    const accounts = await web3.eth.getAccounts();

    if (accounts && accounts[0]) {
      this.token = new ERC20Token(web3, this.contractAddress, accounts[0]);
      this.totalSupply = await this.token.totalSupply();
      this.price = Web3.utils.fromWei(await this.token.price());
    }
  },

  methods: {
    async checkBalance() {
      this.balance = await this.token.balanceOf(this.address);
    },

    async transferToken() {
      await this.token.transfer(this.transfer.to, this.transfer.value);
    },

    async buy() {
      await this.token.buy(this.buyAmount);
    },
  },
};
</script>

<style>
</style>
