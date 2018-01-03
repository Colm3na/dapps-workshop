<template>
<div>
  <q-layout>

    <q-toolbar slot="header" color="primary">
      <q-toolbar-title>
        Reservations
      </q-toolbar-title>

      <provider-selector v-on:account-change="updateAccount" />
    </q-toolbar>

    <div class="layout-view">

      <div class="token" align="center">
         <h6> {{ (new Date()).toLocaleDateString() }} </h6>
       </div>

      <div class="row justify-center">
        <div class="col-md-auto" v-for="room in rooms" :key="room.id">
          <q-card class="sala">

            <q-card-title>
              Room {{ room.id }}
              <div slot="right" class="row items-center">
                <q-icon name="people" /> &nbsp; {{ room.capacity }}
              </div>
            </q-card-title>

            <q-list>
              <q-item v-if="room.slots.length === 0">
                <q-item-main>
                  <q-item-tile color="faded" align="center">No slot available</q-item-tile>
                </q-item-main>
              </q-item>

              <q-item v-for="slot in room.slots" :key="slot.id">
                <q-item-side v-if="slot.status === 0" icon="event_busy" color="faded" />
                <q-item-side v-else-if="slot.status === 1" icon="event_available" color="positive" />
                <q-item-side v-else icon="event_busy" color="negative" />

                <q-item-main>
                  <q-item-tile>{{ slot.data }}</q-item-tile>
                </q-item-main>

                <q-item-side right>
                  <q-btn icon="access_time" small round :class="{ disabled : slot.status !== 1 }"></q-btn>
                </q-item-side>
              </q-item>
            </q-list>
          </q-card>
        </div>
      </div>
    </div>
  </q-layout>
</div>
</template>

<script>
import {
  QLayout,
  QToolbar,
  QToolbarTitle,
  QBtn,
  QIcon,
  QList,
  QListHeader,
  QItem,
  QItemSide,
  QItemMain,
  QItemTile,
  QCard,
  QCardMain,
  QCardTitle,
  QCardMedia,
} from 'quasar';
import ProviderSelector from './ProviderSelector';
import Booking from 'assets/Booking';

export default {
  name: 'index',
  components: {
    QLayout,
    QToolbar,
    QToolbarTitle,
    QBtn,
    QIcon,
    QList,
    QListHeader,
    QItem,
    QItemSide,
    QItemMain,
    QItemTile,
    QCard,
    QCardMain,
    QCardTitle,
    QCardMedia,
    ProviderSelector,
  },
  data() {
    return {
      balance: 0,
      rooms: [],
    };
  },
  methods: {
    async updateAccount(account) {
      const { web3 } = account;

      const booking = new Booking(
        web3.currentProvider,
        process.env.CONTRACT_ADDRESS,
      );

      const ids = await booking.listRoomsIds();
      this.rooms = await booking.getRooms(ids, Date.now() / 1000);
    },
  },
};
</script>

<style lang="styl">

@import '~variables';

div.sala
  width 19em

div.token
  border-radius 0px
  margin-bottom 20px
  background-color $tertiary

</style>
