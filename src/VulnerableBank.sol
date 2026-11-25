// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableBank {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Vulnerability: anyone can change the owner
    function changeOwner(address newOwner) public {
        require(newOwner != address(0), "Invalid address");

        owner = newOwner;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}
