const erc20token = artifacts.require("./erc20Token.sol");
const SupplyChain = artifacts.require("./SupplyChain.sol");

module.exports = function(delpoyer) {
    delpoyer.deploy(erc20token, 100000000, "SCM Tocken", 18, "SCMT");
    delpoyer.deploy(SupplyChain);
}