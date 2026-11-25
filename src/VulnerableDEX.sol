// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableDEX {
    uint256 public tokenPrice = 0.01 ether;

    mapping(address => uint256) public tokens;

    event TokensPurchased(
        address indexed buyer,
        uint256 ethPaid,
        uint256 tokensReceived
    );

    function buy() external payable {
        require(msg.value > 0, "Send ETH");

        uint256 amount = msg.value / tokenPrice;

        require(amount > 0, "Insufficient ETH");

        tokens[msg.sender] += amount;

        // Le prix augmente après chaque achat
        tokenPrice += 0.001 ether;

        emit TokensPurchased(msg.sender, msg.value, amount);
    }
}
