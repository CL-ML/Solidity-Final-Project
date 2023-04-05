// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LeaseContract {
    uint256 public rentAmount;
    uint256 public leaseDuration;
    uint256 public securityDepositMonths;
    uint256 public amountDeposited = 0;
    uint256 public rentPaid = 0;
    uint256 public ownerWithdrawn = 0;
    address public renter;
    address public owner;
    address public guarantee;
    uint256 public startDate;

    mapping(address => uint256) public deposits;

    modifier onlyGuarantee() {
        require(
            msg.sender == guarantee,
            "Only the guarantee can call this function."
        );
        _;
    }

    constructor(
        uint256 _rentAmount,
        uint256 _leaseDuration,
        uint256 _securityDepositMonths,
        address _renter
    ) {
        rentAmount = _rentAmount;
        leaseDuration = _leaseDuration;
        securityDepositMonths = _securityDepositMonths;
        renter = _renter;
        owner = msg.sender;
        startDate = block.timestamp;
    }

    function deposit() public payable onlyGuarantee {
        if (guarantee == address(0)) {
            guarantee = msg.sender;
        }
        amountDeposited += msg.value;
        deposits[msg.sender] += msg.value;
    }

    function payRent() public payable {
        rentPaid += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can withdraw.");
        require(
            amount <= rentPaid - ownerWithdrawn,
            "Cannot withdraw more than available rent."
        );

        ownerWithdrawn += amount;
        payable(owner).transfer(amount);
    }
}
