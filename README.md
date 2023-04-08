# Solidity Lease Campaign Project

This project is a decentralized lease campaign system built on top of the Ethereum blockchain using Solidity. It enables a transparent and secure way of managing lease campaigns, proposals, and rent payments. The system consists of three main contracts: CampaignFactory, CampaignContract, and LeaseContract. In this document, we will explain the project in detail, covering the purpose and functionalities of each contract, as well as the tests that ensure their proper operation.

## Overview

In the context of leasing properties, both renters and landlords can benefit from a decentralized system that provides transparency, security, and automation. The Solidity Lease Campaign project aims to create such a system by leveraging smart contracts on the Ethereum blockchain.

The system allows a renter to create a campaign for leasing a property. Landlords can then submit proposals for the property, and the renter can accept a proposal. Once a proposal is accepted, a lease contract is automatically created. Guarantors can fund the campaign to cover rent payments, and the landlord can withdraw their rent payments.

## Contracts

### 1. CampaignFactory

The CampaignFactory contract serves as a hub for creating and managing CampaignContract instances. Its primary responsibilities include:

Maintaining a list of created campaigns.
Allowing users to create new campaigns by specifying the necessary details, such as rent amount, rent duration, and the minimum guarantee required.
By centralizing the creation and management of campaigns, the CampaignFactory simplifies the process of launching new campaigns and allows for easier tracking of existing ones.

### 2. CampaignContract

The CampaignContract is the core contract representing a lease campaign. It offers several key functionalities:

Funding the campaign: Anyone can fund the campaign by sending Ether to the contract. The participation of each funder is tracked and stored.
Submitting rent proposals: Landlords can submit rent proposals that include details such as the housing address, rent amount, and rent duration.
Accepting rent proposals: Only the renter can accept a proposal, and they can only do so if there is enough guarantee in the campaign. Once a proposal is accepted, a LeaseContract instance is automatically created, and the address is recorded in the CampaignContract.
Withdrawing funds: While the campaign is active, no one can withdraw funds from the contract. Once the campaign is over, funds can be withdrawn according to the conditions specified in the LeaseContract.
The CampaignContract serves as the main interface for users to interact with lease campaigns, providing a robust and transparent platform for managing property leasing.

### 3. LeaseContract

When a proposal is accepted by the renter in the CampaignContract, a LeaseContract is created. This contract handles the following tasks:

Storing essential information such as the rent amount, rent duration, housing address, campaign address, premium, and landlord address.
Allowing anyone to pay rent for the property. The contract increments the amountPaid variable each time a payment is made. It requires that the input amount is greater than 0.
Calculating the total rent amount to be paid based on the rent amount and the number of months passed since the contract started. This information is accessible through the amountToBePaid view function.
Enabling the landlord to withdraw the rent amount available for withdrawal. The contract checks if the caller is the landlord and if there is any rent amount available for withdrawal. If the amount available is less than or equal to the contract balance, it transfers the rent to the landlord. If the contract balance is not sufficient, it withdraws the remaining amount from the campaign contract and transfers the entire amount to the landlord.
Allowing the lease contract to send the premium to the CampaignContract after the lease contract finishes. The contract calculates the total premium amount to be paid, checks if the contract balance is sufficient, and sends the premium amount to the CampaignContract. Finally, it changes the premiumPaid status in the CampaignContract.
The LeaseContract is responsible for managing the rent payments and the interaction between the landlord and the renter, ensuring a secure and transparent leasing process.

## Tests

To ensure that the system works as expected, several tests have been developed to cover the main functionalities of each contract.

### CampaignFactory Tests

Verify that anyone can create a campaign.
Confirm that each new campaign is added to the list of campaigns.

### CampaignContract Tests

Test that anyone can fund the campaign and that they cannot withdraw funds if the campaign is not finished.
Ensure that anyone can submit a rent proposal.
Verify that only the renter can accept a proposal and that they can only do so if there is enough guarantee to cover all the rents from the proposal.

### LeaseContract Tests

Check that anyone can add money to pay the rent, and ensure they cannot withdraw it once it is paid.
Test that the landlord can withdraw rents after a certain amount of time has passed. For example, after two months, the landlord should be able to withdraw two rents.

## Conclusion

The Solidity Lease Campaign project is a decentralized leasing system built on the Ethereum blockchain that offers a transparent, secure, and automated way of managing lease campaigns, proposals, and rent payments. With detailed explanations of each contract, their purpose, functionalities, and tests, this README serves as a comprehensive guide to understanding and using the system effectively.
