// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CampaignContract.sol";

contract CampaignFactory {
    address[] public deployedCampaigns;

    event CampaignCreated(address indexed newCampaign);

    // Create a new campaign for the message sender
    function createCampaign(
        uint256 _maxRent,
        uint256 _maxRentDuration,
        uint256 _campaignDuration,
        uint256 _premium
    ) public {
        address newCampaign = address(
            new CampaignContract(
                msg.sender,
                _maxRent,
                _maxRentDuration,
                _campaignDuration,
                _premium
            )
        );
        deployedCampaigns.push(newCampaign);
        emit CampaignCreated(newCampaign);
    }

    // Give all the deployed campaigns
    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }
}
