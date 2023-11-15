// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Assessment {
    address payable public owner;
    uint256 public balance;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdraw(address indexed withdrawer, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(uint256 initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function deposit(uint256 _amount) public payable {
        uint256 _previousBalance = balance;

        // Ensure the caller is the owner
        require(msg.sender == owner, "You are not the owner of this account");

        // Perform the transaction
        balance += _amount;

        // Emit the Deposit event
        emit Deposit(msg.sender, _amount);

        // Assert that the transaction completed successfully
        assert(balance == _previousBalance + _amount);
    }

    // Custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        // Ensure the caller is the owner
        require(msg.sender == owner, "You are not the owner of this account");

        uint256 _previousBalance = balance;

        // Check if the balance is sufficient for withdrawal
        if (balance < _withdrawAmount) {
            revert InsufficientBalance(balance, _withdrawAmount);
        }

        // Withdraw the given amount
        balance -= _withdrawAmount;

        // Emit the Withdraw event
        emit Withdraw(msg.sender, _withdrawAmount);

        // Assert that the balance is correct
        assert(balance == _previousBalance - _withdrawAmount);
    }

    function transferOwnership(address payable _newOwner) public {
        // Ensure the caller is the current owner
        require(msg.sender == owner, "You are not the owner of this account");

        // Ensure the new owner address is valid
        require(_newOwner != address(0), "Invalid new owner address");

        // Transfer ownership to the new address
        address payable previousOwner = owner;
        owner = _newOwner;

        // Emit the OwnershipTransferred event
        emit OwnershipTransferred(previousOwner, _newOwner);
    }
}

//coded by Rhuzz
