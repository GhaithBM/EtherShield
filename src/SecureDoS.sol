// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureDoS {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        require(msg.value > 0, "Send ETH");

        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];

        require(amount > 0, "No balance");

        // Checks-Effects-Interactions
        balances[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");

        require(success, "Withdrawal failed");
    }
}
