// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureWallet {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw() public {
        // Secure authentication
        require(msg.sender == owner, "Not owner");

        uint256 amount = address(this).balance;

        (bool success, ) = payable(msg.sender).call{value: amount}("");

        require(success, "Transfer failed");
    }

    receive() external payable {}
}
