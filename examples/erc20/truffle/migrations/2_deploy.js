var BasicToken = artifacts.require('./BasicToken.sol');

module.exports = function(deployer) {
  deployer.deploy(BasicToken, 0, 1e15);
};
