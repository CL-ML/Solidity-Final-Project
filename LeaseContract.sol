// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LeaseContract {
    uint256 public rentAmount;
    uint256 public leaseDuration;
    uint256 public securityDepositMonths;
    address public renter;
    address public owner;

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
    }
}
