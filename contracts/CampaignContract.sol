// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LeaseContract.sol";

contract CampaignContract {
    address public renter;
    uint256 public maxRent;
    uint256 public maxRentDuration;
    uint256 public campaignDuration;
    uint256 public premium;
    uint256 public deploymentTime;
    uint256 public objectiveAmount;
    uint256 public totalFunded;
    bool public proposalAccepted;
    uint256 public guaranteeUsed;
    bool public premiumPaid;

    address public leaseContractAddress;

    mapping(address => uint256) public guarantorFunds;
    mapping(uint256 => RentProposal) public rentProposals;
    uint256 public rentProposalCounter;

    struct RentProposal {
        string housingAddress;
        uint256 rentAmount;
        uint256 rentDuration;
        address payable landLord;
    }

    // Initializes the CampaignContract with required parameters.
    constructor(
        address _renter,
        uint256 _maxRent,
        uint256 _maxRentDuration,
        uint256 _campaignDuration,
        uint256 _premium
    ) {
        renter = _renter;
        maxRent = _maxRent;
        maxRentDuration = _maxRentDuration;
        campaignDuration = _campaignDuration;
        premium = _premium;
        deploymentTime = block.timestamp;
        objectiveAmount = _maxRent * _maxRentDuration;
        totalFunded = 0;
        rentProposalCounter = 0;
        proposalAccepted = false;
        premiumPaid = false;
    }

    // Calculates the premium at the current time.
    function currentPremium() public view returns (uint256) {
        if (totalFunded >= objectiveAmount) {
            return premium;
        }

        uint256 elapsedDays = (block.timestamp - deploymentTime) / 1 days;
        if (elapsedDays >= campaignDuration) {
            return premium;
        }

        uint256 halfDuration = campaignDuration / 2;
        if (elapsedDays <= halfDuration) {
            return (premium * elapsedDays) / halfDuration;
        } else {
            return premium;
        }
    }

    // Allows users to contribute funds as guarantors.
    function participate() public payable {
        require(msg.value > 0, "Participation amount must be non-zero.");
        require(
            totalFunded + msg.value <= objectiveAmount,
            "Exceeds objective amount."
        );
        require(
            proposalAccepted == false,
            "The campaign is not running anymore, the rent has begun"
        );

        if (totalFunded + msg.value == objectiveAmount) {
            premium = currentPremium();
        }

        totalFunded += msg.value;
        guarantorFunds[msg.sender] += msg.value;
    }

    // Guarantors can withdraw their funds after conditions met.
    function withdraw() public {
        require(
            block.timestamp >= deploymentTime + campaignDuration * 1 days,
            "Campaign not finished yet."
        );
        require(guarantorFunds[msg.sender] > 0, "Nothing to withdraw.");

        uint256 amount;
        uint256 guaranteeRemaining;
        if (proposalAccepted) {
            uint256 leaseContractEndDate = LeaseContract(leaseContractAddress)
                .startDate() + maxRentDuration * 30 days;
            require(
                block.timestamp >= leaseContractEndDate,
                "Cannot withdraw before lease contract ends."
            );
            guaranteeRemaining = objectiveAmount - guaranteeUsed;
            amount =
                (guarantorFunds[msg.sender] * guaranteeRemaining) /
                objectiveAmount;
            require(premiumPaid, "Premium not paid to CampaignContract.");
        } else {
            amount = guarantorFunds[msg.sender];
        }

        guarantorFunds[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    // Allows users to submit rental proposals.
    function rentProposal(
        string memory _housingAddress,
        uint256 _rentAmount,
        uint256 _rentDuration
    ) public {
        require(_rentAmount <= maxRent, "Rent amount exceeds maximum rent.");
        require(
            _rentDuration <= maxRentDuration,
            "Rent duration exceeds maximum duration."
        );

        rentProposals[rentProposalCounter] = RentProposal({
            housingAddress: _housingAddress,
            rentAmount: _rentAmount,
            rentDuration: _rentDuration,
            landLord: payable(msg.sender)
        });
        rentProposalCounter++;
    }

    // Renter can accept a rental proposal that meets conditions.
    function acceptProposal(uint256 proposalId) public onlyRenter {
        require(!proposalAccepted, "A proposal has already been accepted.");

        RentProposal storage proposal = rentProposals[proposalId];
        uint256 requiredGuarantee = proposal.rentAmount * proposal.rentDuration;
        require(
            totalFunded >= requiredGuarantee,
            "Not enough guarantee for this proposal."
        );

        leaseContractAddress = address(
            new LeaseContract(
                proposal.rentAmount,
                proposal.rentDuration,
                proposal.housingAddress,
                address(this),
                premium,
                proposal.landLord
            )
        );
        proposalAccepted = true;
    }

    modifier onlyRenter() {
        require(msg.sender == renter, "Caller is not the renter.");
        _;
    }

    // Transfers funds from CampaignContract to a recipient.
    function sendFunds(uint256 amount, address payable recipient) public {
        require(
            msg.sender == leaseContractAddress,
            "Only the lease contract can call this function."
        );
        recipient.transfer(amount);
        guaranteeUsed += amount;
    }

    // Marks the premium as paid in CampaignContract.
    function changePremiumPaid() public {
        require(
            msg.sender == leaseContractAddress,
            "Only the lease contract can call this function."
        );
        premiumPaid = true;
    }
}
