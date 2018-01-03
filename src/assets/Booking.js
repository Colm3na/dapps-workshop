import BookingContract from '../../build/contracts/Booking.json';
import Web3 from 'web3';
import _ from 'lodash';

function buildSlotFormatter(dataFormatter) {
  return ([status, data], idx) => ({
    id: idx,
    status: parseInt(status, 10),
    data: dataFormatter(data),
  });
}

function buildRoomsFormatter(slotFormatter) {
  return ([id, { capacity, status, data }]) => ({
    id,
    capacity,
    slots: _.zip(status, data)
      .map(slotFormatter)
      .filter(({ data: d }) => d),
  });
}

const utf8DataFormatter = Web3.utils.hexToUtf8;

const slotFormatter = buildSlotFormatter(utf8DataFormatter);

const roomsFormatter = buildRoomsFormatter(slotFormatter);

export default class Booking {
  constructor(provider, address) {
    const web3 = new Web3(provider);
    this.contract = new web3.eth.Contract(BookingContract.abi, address);
  }

  listRoomsIds() {
    return this.contract.methods.listRooms().call();
  }

  async getRooms(ids, timestamp) {
    const rooms = await Promise.all(
      ids.map(id => this.contract.methods.getRoom(id, timestamp).call()),
    );

    return _.zip(ids, rooms).map(roomsFormatter);
  }
}
