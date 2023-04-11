# GuarantEase

Short description

## Team
- Cedric Lion : Project Lead and Smart contract developer
- Laetitia Assor : Business development
- Yangjiawei Xue : javascript test developer

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

## SDLC process milestones

## Timeline


