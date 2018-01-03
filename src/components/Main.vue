<template>
<div>
  <q-layout>

    <q-toolbar slot="header" color="negative">
      <q-toolbar-title>
        Rooms reservation
      </q-toolbar-title>

      <provider-selector v-on:account-change="updateAccount" />
    </q-toolbar>

    <div class="layout-view">

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
              <q-item v-for="slot in room.slots" :key="slot.data">
                <q-item-side v-if="!slot.enabled" icon="event_busy" color="faded" />
                <q-item-side v-else-if="slot.available" icon="event_available" color="positive" />
                <q-item-side v-else icon="event_busy" color="negative" />

                <q-item-main>
                  <q-item-tile v-if="slot.enabled">{{ slot.data }}</q-item-tile>
                  <q-item-tile v-if="!slot.enabled">Unavailable slot</q-item-tile>
                </q-item-main>

                <q-item-side right>
                  <q-btn icon="access_time" small round :class="{ disabled : !slot.enabled || !slot.available }"></q-btn>
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
import BookingContract from '../../output/Booking.json';
import _ from 'lodash';

function buildSlotFormatter(dataFormatter) {
  return function([enabled, available, data]) {
    return {
      enabled,
      available,
      data: dataFormatter(data),
    };
  };
}

function buildRoomsFormatter(slotFormatter) {
  return function([id, availability, { capacity, enabled, data }]) {
    return {
      id,
      capacity,
      slots: _.zip(enabled, availability, data).map(slotFormatter),
    };
  };
}

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

      const booking = new web3.eth.Contract(
        BookingContract.abi,
        '0x4bc59d2c475cc34aefd292069de064051346183b',
      );

      const timestamp = Math.floor(Date.now() / 1000);
      console.log(timestamp);

      const roomsIds = await booking.methods.listRoomsIds().call();
      const roomsData = await Promise.all(
        roomsIds.map(id => booking.methods.getRoom(id).call()),
      );
      const roomsAvailability = await Promise.all(
        roomsIds.map(id =>
          Promise.all(
            _.range(6).map(({}, i) =>
              booking.methods.checkAvailability(id, i, timestamp).call(),
            ),
          ),
        ),
      );

      const roomsFormatter = buildRoomsFormatter(
        buildSlotFormatter(web3.utils.hexToUtf8),
      );
      const rooms = _.zip(roomsIds, roomsAvailability, roomsData).map(
        roomsFormatter,
      );

      this.rooms = rooms;
    },
  },
};
</script>

<style>
.layout-view {
  margin-top: 2em;
  margin-left: 10em;
  margin-right: 10em;
}

.sala {
  width: 19em;
}
</style>
