// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CampaignContract.sol";

contract LeaseContract {
    uint256 public rentAmount;
    uint256 public rentDuration;
    string public housingAddress;
    address public campaignAddress;
    address payable public landLord;
    uint256 public premium;
    uint256 public startDate;
    uint256 public amountPaid;
    uint256 public amountWithdrawn;
    CampaignContract public campaignContract;

    // Initializes the LeaseContract with required parameters.
    constructor(
        uint256 _rentAmount,
        uint256 _rentDuration,
        string memory _housingAddress,
        address _campaignAddress,
        uint256 _premium,
        address payable _landLord
    ) {
        rentAmount = _rentAmount;
        rentDuration = _rentDuration;
        housingAddress = _housingAddress;
        campaignAddress = _campaignAddress;
        premium = _premium;
        startDate = block.timestamp;
        amountPaid = 0;
        landLord = _landLord;
        campaignContract = CampaignContract(_campaignAddress);
    }

    // Allows users to pay rent for the property.
    function payRent() public payable {
        require(msg.value > 0, "Payment should be greater than 0");
        amountPaid += msg.value;
    }

    // Calculates total rent to be paid up to the current time.
    function amountToBePaid() public view returns (uint256) {
        uint256 monthsPassed = (block.timestamp - startDate) / 30 days;
        if (monthsPassed >= rentDuration) {
            monthsPassed = rentDuration;
        }
        uint256 totalAmount = (rentAmount) * monthsPassed;
        return totalAmount;
    }

    // Allows the landlord to withdraw available rent.
    function withdrawRent() public {
        require(
            msg.sender == landLord,
            "Only the landlord can withdraw the rent."
        );
        uint256 amountAvailable = amountToBePaid() - amountWithdrawn;
        require(amountAvailable > 0, "No rent available for withdrawal.");

        if (amountAvailable <= address(this).balance) {
            amountWithdrawn += amountAvailable;
            payable(msg.sender).transfer(amountAvailable);
        } else {
            uint256 amountToWithdraw = amountAvailable - address(this).balance;
            campaignContract.sendFunds(amountToWithdraw, landLord);
            amountWithdrawn += amountAvailable;
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    // Sends premium to campaign contract after lease ends.
    function sendPremiumToCampaign() public {
        require(
            block.timestamp > startDate + rentDuration * 30 days,
            "Contract not finished yet."
        );
        uint256 premiumToPay = premium * rentDuration;
        uint256 amountAvailable = address(this).balance -
            (amountToBePaid() - amountWithdrawn);
        require(
            amountAvailable >= premiumToPay,
            "Contract balance is insufficient."
        );

        campaignContract.participate{value: premiumToPay}();
        campaignContract.changePremiumPaid();
    }
}
