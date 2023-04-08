const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CampaignContract", function () {
  let CampaignContract, campaignContract, renter, addr1, addr2, landLord;

  beforeEach(async function () {
    CampaignContract = await ethers.getContractFactory("CampaignContract");
    [renter, addr1, addr2, landLord] = await ethers.getSigners();
    campaignContract = await CampaignContract.deploy(
      renter.address,
      1000, // maxRent
      12, // maxRentDuration
      30, // campaignDuration
      200 // premium
    );
  });

  it("should allow anyone to fund the campaign, and track the participation", async function () {
    await campaignContract.connect(addr1).participate({ value: 100 });
    await campaignContract.connect(addr2).participate({ value: 200 });

    const addr1Funds = await campaignContract.guarantorFunds(addr1.address);
    const addr2Funds = await campaignContract.guarantorFunds(addr2.address);

    expect(addr1Funds).to.equal(100);
    expect(addr2Funds).to.equal(200);
  });

  it("should not allow anyone to withdraw funds if the campaign is not finished", async function () {
    await campaignContract.connect(addr1).participate({ value: 100 });
    await campaignContract.connect(addr2).participate({ value: 200 });

    await expect(campaignContract.connect(addr1).withdraw()).to.be.revertedWith(
      "Campaign not finished yet."
    );
  });

  it("should allow nobody but the renter to accept a proposal, and only if there is enough guarantee", async function () {
    await campaignContract
      .connect(landLord)
      .rentProposal("Housing Address", 1000, 6);

    await expect(
      campaignContract.connect(landLord).acceptProposal(0)
    ).to.be.revertedWith("Caller is not the renter.");

    await expect(
      campaignContract.connect(renter).acceptProposal(0)
    ).to.be.revertedWith("Not enough guarantee for this proposal.");

    await campaignContract.connect(addr1).participate({ value: 8000 });
    await expect(campaignContract.connect(renter).acceptProposal(0)).not.to.be
      .reverted;
  });

  it("should have created a LeaseContract if a proposal is accepted, and the address should be recorded", async function () {
    const [_, __, landLord, addr1] = await ethers.getSigners();

    await campaignContract
      .connect(landLord)
      .rentProposal("Housing Address", 1000, 6);

    await campaignContract.connect(addr1).participate({ value: 8000 });

    await expect(campaignContract.connect(renter).acceptProposal(0)).not.to.be
      .reverted;

    const leaseContractAddress = await campaignContract.leaseContractAddress();
    expect(leaseContractAddress).not.to.equal(ethers.constants.AddressZero);

    console.log("Address of the new LeaseContract:", leaseContractAddress);
  });
});
