// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureVault {

    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");

        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() external {
        // CHECKS
        uint256 amount = balances[msg.sender];

        require(amount > 0, "Insufficient balance");

        // EFFECTS
        balances[msg.sender] = 0;

        // INTERACTIONS
        (bool success, ) = payable(msg.sender).call{value: amount}("");

        require(success, "Transfer failed");

        emit Withdrawal(msg.sender, amount);
    }
}
