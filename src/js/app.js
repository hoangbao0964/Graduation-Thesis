App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Is there is an injected web3 instance?
    if (typeof web3 !== "undefined") {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // If no injected web3 instance is detected, fallback to Ganache.
      App.web3Provider = new web3.providers.HttpProvider(
        "http://127.0.0.1:1502"
      );
      web3 = new Web3(App.web3Provider);
      console.log("Connected to Ganache");
    }
    return App.initCrowdfundingContract();
  },

  initCrowdfundingContract: function() {
    $.getJSON("CrowdfundingCampaign.json", function(crowdfunding) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Crowdfunding = TruffleContract(crowdfunding);
      // Connect provider to interact with contract
      App.contracts.Crowdfunding.setProvider(App.web3Provider);
      web3.eth.defaultAccount = web3.eth.accounts[0];
      return App.bindEvents();
    });
  },

  bindEvents: function() {
    console.log("Events loaded");
    $("#createNewProjectButton").click(App.loadCreateNewProjectModal);
  },

  loadCreateNewProjectModal: function() 
  {
    console.log(web3.eth.accounts[0]);
    web3.eth.accounts.forEach(function(e) {
      $("#createNewProjectModalOwnerSelect").append('<option>'+ e +'</option>');
    });
  },

  render: function() {
    var electionInstance;
    var loader = $("#loadProjects");
    var content = $("#content");

    loader.show();
  },
  markAdopted: function(adopters, account) {
    /*
     * Replace me...
     */
  },

  handleAdopt: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data("id"));

    /*
     * Replace me...
     */
  }
};
$(function() {
  $(window).on("load", function() {
    App.init();
  });
});
