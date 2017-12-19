const Booking = artifacts.require('./Booking.sol');
const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');

chai.use(chaiAsPromised);
const should = chai.should();

contract('Booking', () => {
  it('Should create a contract with a limit of days in advance allowed to book', async () => {
    const bookingInstance = await Booking.new(2);
    const maxDays = await bookingInstance.maxDays.call();

    maxDays.toString().should.equal('2');
  });

  it('Should fail when max days is set to zero', async () => {
    let exception;

    try {
      await Booking.new(0);
    } catch (e) {
      exception = e;
    }

    should.exist(exception);
  });

  it('Should fail to create a contract without max days', async () => {
    let exception;

    try {
      await Booking.new();
    } catch (e) {
      exception = e;
    }

    should.exist(exception);
  });
});
