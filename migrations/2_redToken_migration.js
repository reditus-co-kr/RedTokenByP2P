//const RedTokenBase = artifacts.require('RedTokenBase');
//const RedTokenOwnership = artifacts.require('RedTokenOwnership');
const RedTokenCore = artifacts.require('RedTokenCore');

module.exports = function(deployer, network, accounts) {

    //deployer.deploy(RedTokenBase).then(function(){});
    //deployer.deploy(RedTokenOwnership).then(function(){});
    deployer.deploy(RedTokenCore); //, {gas: 8015591, from: "0x8453eE0e06168d27B151ccb190b125b69D02c0Ac"}
    // deployer.deploy(RedTokenOwnership).then(function() {
    //     return deployer.deploy(RedTokenCore, RedTokenOwnershipInstance.address);
    // });

};