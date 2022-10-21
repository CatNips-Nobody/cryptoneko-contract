var CryptoNeko = artifacts.require("CryptoNeko");
module.exports = function(deployer) {
  deployer.deploy(CryptoNeko);
};