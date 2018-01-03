<template>
<div>
  <q-stepper ref="stepper" color="primary" flat>

    <q-step name="node" title="Connect to a node">
      <h6>Please, provide a custom Ethereum node</h6>

      <q-field :error="isError" :error-label="error">
        <q-input v-model="providerUrl" float-label="RPC address" />
      </q-field>

      <q-stepper-navigation>
        <q-btn color="primary" @click="addProvider()">Next</q-btn>
        <q-btn color="primary" @click="close()" flat>Cancel</q-btn>
      </q-stepper-navigation>

    </q-step>

    <q-step name="address" title="Select address">

      <h6>Select address</h6>

      <q-list link highlight separator>
        <q-item tag="label" v-for="account in accounts" :key="account.address">
          <q-item-side>
            <q-radio v-model="selectAddress" :val="account.address" />
          </q-item-side>
          <q-item-main>
            <q-item-tile label> {{ account.address }} </q-item-tile>
          </q-item-main>
          <q-item-side :stamp="account.balance" right />
        </q-item>
      </q-list>

      <q-stepper-navigation>
        <q-btn color="primary" @click="addAccount">Finish</q-btn>
        <q-btn color="primary" flat @click="$refs.stepper.previous()">Back</q-btn>
      </q-stepper-navigation>

    </q-step>

    <q-inner-loading :visible="inProgress" />
  </q-stepper>
</div>
</template>

<script>
import {
  QBtn,
  QList,
  QItem,
  QItemMain,
  QItemSide,
  QItemTile,
  QStep,
  QStepper,
  QStepperNavigation,
  QInnerLoading,
  QField,
  QInput,
  QRadio,
} from 'quasar-framework';
import Web3 from 'web3';

export default {
  name: 'add-account',
  components: {
    QBtn,
    QList,
    QItem,
    QItemMain,
    QItemSide,
    QItemTile,
    QStep,
    QStepper,
    QStepperNavigation,
    QInnerLoading,
    QField,
    QInput,
    QRadio,
  },
  data() {
    return {
      web3: null,
      accounts: [],
      providerUrl: '',
      selectAddress: '',
      inProgress: false,
      isError: false,
      error: '',
    };
  },
  methods: {
    async addProvider() {
      if (!this.providerUrl) {
        this.isErrorr = true;
        this.error = "Provider can't be blank";
        return;
      }

      try {
        this.inProgress = true;
        this.web3 = new Web3(this.providerUrl);
        if (!this.web3) {
          throw Error('Provider not valid');
        }

        const addresses = await this.web3.eth.getAccounts();
        const accounts = await Promise.all(
          addresses.map(async address => {
            const balance = this.web3.utils.fromWei(
              await this.web3.eth.getBalance(address),
            );

            return {
              address,
              balance: `${balance} Ξ`,
            };
          }),
        );

        this.accounts = accounts;
        this.$refs.stepper.next();
      } catch (e) {
        this.isError = true;
        this.error = e.toString();
      } finally {
        this.inProgress = false;
      }
    },

    addAccount() {
      this.$emit('done', {
        web3: this.web3,
        address: this.selectAddress,
        provider: this.providerUrl,
      });

      this.web3 = null;
      this.selectAddress = '';
      this.providerUrl = '';
      this.isError = false;
      this.error = '';

      this.$refs.stepper.reset();
    },

    close() {
      this.web3 = null;
      this.selectAddress = '';
      this.providerUrl = '';
      this.isError = false;
      this.error = '';

      this.$emit('done');
    },
  },
};
</script>

<style>
.modal-content {
  width: 60em;
  padding: 2em;
}
</style>
