// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SecureBank is Ownable {

    address public currentOwner;

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    constructor() Ownable(msg.sender) {
        currentOwner = msg.sender;
    }

    function changeOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");

        address oldOwner = currentOwner;

        currentOwner = newOwner;

        emit OwnerChanged(oldOwner, newOwner);
    }
}
