The contract has been deployed on Alfajores at this address : 0xDa3D7792C698Cb2377E230A91Ad4aEc04Feab37D

# GuarantEase

GuarantEase is a platform that allows any tenant in search of housing to find a guarantor, and any landlord to ensure that they receive their rent payments. Today, many people like students, freelancers, or new workers, have difficulties in accessing housing. Searching for a rental property is particularly complex and stressful for those who do not have a solid rental application, a stable income, and/or a reliable guarantor. Landlords are reluctant to grant rentals without guarantors and/or stable income as they fear the risk of non-payment of rents. This is a major social problem which we attempt to address with GuarantEase and the blockchain technology. By creating an automated and secure decentralized guarantee system, we help tenants access housing despite a less favorable application and allow landlords to collect their rents for sure on time. 

Our solution is to create a robust system of economic incentives between renters (tenants), owners (landlords) and guarantors. Our blockchain-based guarantee system aims at facilitating the connection between these 3 actors. This guarantee system is implemented through a smart contract which secures and locks the guarantor’s funds, thus ensuring that the rent is paid on time to the landlord. The tenant pays a premium to the guarantor, in compensation for locking up some of his liquidity to cover the risk of non-payment of rents. Besides earning a premium, the guarantor can also decide to invest some of its locked liquidity into Defi protocols like Youves to generate some additional sources of return, at the expense of being exposed to market fluctuations and Defi investments’ associated risks. Therefore, tenants with less solid applications can more easily access housing, landlords are ensured to receive their rent payments, and guarantors are provided attractive returns (from the premium and Defi protocols) in exchange for locking up liquidity and can diversify their risk. 

When a tenant wants to engage in a rental process, he must first create an account of the GuarantEase platform (providing basic personal information) and undergo the “Know your customer” process (KYC): this identity verification process aims at checking the users’ identities, ensuring security and compliance with the current regulations (notably the EU’s GDPR data protection standards), reducing risks of fraud, money laundering and terrorist financing. Once the tenant’s account has been verified, he can launch a guarantee campaign. In his campaign, he must provide any relevant information for potential guarantors like income level, tax situation, employment status. All this information is then processed and analyzed by a scoring algorithm which outputs a risk score. The tenant must also set the risk premium (as a % of the rent) that would remunerate guarantors in exchange for providing their liquidity. This premium should be attractive enough to encourage guarantors to commit while remaining affordable for the tenant. The risk premium is positively correlated with the tenant’s risk profile: the riskier the tenant’s profile is, the higher the risk premium needs to be to sufficiently attract guarantors. The risk premium is a flexible mechanism: tenants can adjust the premium based on changes in their financial situation, credit history, or market trends, as well as based on feedbacks or interactions with potential guarantors on the platform. Guarantors are free to choose from various ongoing guarantee campaigns by examining tenant risk profiles and the proposed risk premiums. Once a tenant has found a guarantor who accepts the proposed risk premium, the tenant can sign a rental contract. The landlord sends the contract through the platform, with information such as duration of the rent, address, and a PDF version of the legal contract. If the tenant accepts the terms, they sign the contract during the key handover, and the smart contract is initiated through a cryptographic signature.

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

- UX/UI : build the visual identity of the brand, think about the user experience, work on the front-end models of the v0
- Front-end development : work with a full-stack developer to build the front-end of the models, and develop all the off-chain back-end
- Smart contract development and auditing : finish the development of smart contracts, and have them audited by a specialized company
- Legal base : work on the legal set-up around our service, and on compliance
- v0 launch and first customers : Deploy the v0 of the web application, and go in search of the first customers to face the market. Deploy marketing means to convince owners and tenants. 

## Timeline and fundings

| Milestone  | Duration          | Cost (USD) |
| :--------------- |:---------------:| -----:|
| UX/UI  |   3 weeks       |  7 000 |
| Front-end development  | 4 weeks             |   6 000 |
| Smart contract development and auditing  | 4 weeks          |    20 000 |
|  Legal base   | 4 weeks          |    15 000 |
|  v0 launch and first customers   | 4 weeks          |    8 000 |


We are seeking a grant of $56,000 to cover the costs of development, security and legal auditing and marketing. This funding will enable us to deliver a high-quality app that meets the needs of our users and addresses the challenges faced in the traditional rent market. We are confident that with the support of the DAO, our dApp can revolutionize the leasing industry and empower landlords, renters, and guarantors alike.

