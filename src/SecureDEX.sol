// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureDEX {
    uint256 public tokenPrice = 0.01 ether;

    mapping(address => uint256) public tokens;

    event TokensPurchased(
        address indexed buyer,
        uint256 ethPaid,
        uint256 tokensReceived
    );

    function buy(uint256 minTokensOut) external payable {
        require(msg.value > 0, "Send ETH");

        uint256 amount = msg.value / tokenPrice;

        require(amount > 0, "Insufficient ETH");

        // Protection contre un prix trop défavorable
        require(amount >= minTokensOut, "Slippage too high");

        tokens[msg.sender] += amount;

        tokenPrice += 0.001 ether;

        emit TokensPurchased(msg.sender, msg.value, amount);
    }
}
