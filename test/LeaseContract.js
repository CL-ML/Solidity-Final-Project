const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LeaseContract", function () {
  let CampaignContract;
  let LeaseContract;
  let campaignContract;
  let leaseContract;
  let renter, landLord, addr1, addr2;

  beforeEach(async function () {
    // Deploy the CampaignContract
    CampaignContract = await ethers.getContractFactory("CampaignContract");
    [deployer, renter, landLord, addr1, addr2] = await ethers.getSigners();
    campaignContract = await CampaignContract.deploy(
      renter.address,
      1000, // maxRent
      12, // maxRentDuration
      30, // campaignDuration
      200 // premium
    );

    await campaignContract.connect(addr1).participate({ value: 12000 });

    // Deploy the LeaseContract
    LeaseContract = await ethers.getContractFactory("LeaseContract");
    leaseContract = await LeaseContract.deploy(
      1000,
      6,
      "Housing Address",
      campaignContract.address,
      1000,
      landLord.address
    );
  });

  it("should allow anyone to pay rent", async function () {
    await leaseContract.connect(addr1).payRent({ value: 500 });
    const amountPaid = await leaseContract.amountPaid();
    expect(amountPaid).to.equal(500);
  });
});
