// test/CampaignFactory.js

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CampaignFactory", function () {
  let CampaignFactory, campaignFactory, CampaignContract, campaignContract;

  beforeEach(async function () {
    // Deploying CampaignFactory
    CampaignFactory = await ethers.getContractFactory("CampaignFactory");
    campaignFactory = await CampaignFactory.deploy();
    await campaignFactory.deployed();

    // Deploying CampaignContract
    CampaignContract = await ethers.getContractFactory("CampaignContract");
    campaignContract = await CampaignContract.deploy(
      ethers.constants.AddressZero,
      1000,
      12,
      30,
      100
    );
    await campaignContract.deployed();
  });

  it("Should deploy a new CampaignContract and emit the CampaignCreated event", async function () {
    // Create a new CampaignContract using the CampaignFactory
    await expect(campaignFactory.createCampaign(1000, 12, 30, 100)).to.emit(
      campaignFactory,
      "CampaignCreated"
    );
  });

  it("Should have the created CampaignContract in the deployedCampaigns array", async function () {
    // Create a new CampaignContract using the CampaignFactory
    const createCampaignTx = await campaignFactory.createCampaign(
      1000,
      12,
      30,
      100
    );
    const createCampaignReceipt = await createCampaignTx.wait();
    const createdCampaignEvent = createCampaignReceipt.events.find(
      (event) => event.event === "CampaignCreated"
    );
    const createdCampaignAddress = createdCampaignEvent.args.newCampaign;

    // Get the deployed campaigns array
    const deployedCampaigns = await campaignFactory.getDeployedCampaigns();

    // Check if the created CampaignContract is in the deployedCampaigns array
    expect(deployedCampaigns).to.include(createdCampaignAddress);
  });
});
