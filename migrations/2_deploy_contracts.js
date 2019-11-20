var CrowdfundingContract = artifacts.require("./CrowdfundingCampaign.sol");

module.exports = function(deployer) {
  deployer.deploy(CrowdfundingContract);
};
