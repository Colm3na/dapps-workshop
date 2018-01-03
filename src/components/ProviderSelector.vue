<template>
<div>
  <q-select v-model="accountSelect" :options="options" @change="selectProvider" stack-label="Account"
    separator inverted color="secondary" />

  <q-modal ref="basicModal">
    <add-account v-on:done="newAccount" />
  </q-modal>
</div>
</template>

<script>
import {
  QList,
  QItem,
  QItemMain,
  QItemSide,
  QItemTile,
  QBtn,
  QSelect,
  QModal,
  QField,
  QInput,
} from 'quasar';
import Web3 from 'web3';
import AddAccount from './AddAccount';

export default {
  name: 'provider-selector',
  components: {
    QList,
    QItem,
    QItemMain,
    QItemSide,
    QItemTile,
    QBtn,
    QSelect,
    QModal,
    QField,
    QInput,
    AddAccount,
  },
  data() {
    return {
      accountSelect: 0,
      previousAccountSelect: 0,
      accounts: [],
      modal: {
        label: 'Modal',
        ref: 'basicModal',
      },
    };
  },
  computed: {
    options() {
      const options = this.accounts.map((account, i) => ({
        label: account.address,
        sublabel: account.provider,
        stamp: `${account.balance} Ξ`,
        value: i,
      }));

      if (options.length < 1) {
        options.push({
          label: 'No accounts available',
          value: 0,
        });
      }

      options.push({
        label: 'New account',
        value: null,
        icon: 'add_circle',
      });

      return options;
    },
  },
  async created() {
    if (Web3.givenProvider) {
      const web3 = new Web3(Web3.givenProvider);
      const addresses = await web3.eth.getAccounts();
      const accounts = await Promise.all(
        addresses.map(async address => {
          return {
            web3,
            address,
            provider: 'Injected',
            balance: web3.utils.fromWei(await web3.eth.getBalance(address)),
          };
        }),
      );

      accounts.map(account => this.accounts.push(account));
      const currentAccount = accounts[0];
      currentAccount && this.$emit('account-change', currentAccount);
    }
  },
  methods: {
    async newAccount(account) {
      this.$refs[this.modal.ref].close();

      if (account) {
        account.balance = account.web3.utils.fromWei(
          await account.web3.eth.getBalance(account.address),
        );
        this.accounts.push(account);
      }
    },

    selectProvider(provider) {
      if (this.accountSelect !== null) {
        this.previousAccountSelect = this.accountSelect;

        const currentAccount = this.accounts[this.accountSelect];
        currentAccount && this.$emit('account-change', currentAccount);
      } else {
        this.accountSelect = this.previousAccountSelect;
        this.$refs[this.modal.ref].open();
      }
    },
  },
};
</script>

<style>
</style>
