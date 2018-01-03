const Booking = artifacts.require('./Booking.sol');

module.exports = deployer => {
  deployer.deploy(Booking, 2);
};
