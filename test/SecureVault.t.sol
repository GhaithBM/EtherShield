
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SecureVault.sol";
import "../src/SecureAttacker.sol";

contract SecureVaultTest is Test {

    SecureVault vault;
    SecureAttacker attacker;

    address victim = makeAddr("victim");
    address attackerEOA = makeAddr("attackerEOA");

    function setUp() public {
        // Deploy SecureVault
        vault = new SecureVault();

        // Deploy SecureAttacker
        attacker = new SecureAttacker(address(vault));

        // Give 5 ETH to victim
        vm.deal(victim, 5 ether);

        // Victim deposits 5 ETH
        vm.prank(victim);
        vault.deposit{value: 5 ether}();

        // Give 1 ETH to attacker
        vm.deal(attackerEOA, 1 ether);
    }

    function testReentrancyAttackBlocked() public {
        // Initial vault balance
        assertEq(address(vault).balance, 5 ether);

        // Expect the attack to fail
        vm.expectRevert(
            abi.encodeWithSignature(
                "Error(string)",
                "Transfer failed"
            )
        );

        vm.prank(attackerEOA);
        attacker.attack{value: 1 ether}();

        // Victim's funds remain safe
        assertEq(address(vault).balance, 5 ether);

        // Attacker has no remaining vault balance
        assertEq(vault.balances(address(attacker)), 0);
    }
}
