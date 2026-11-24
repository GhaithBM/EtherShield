
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {VulnerableVault} from "../src/VulnerableVault.sol";
import {Attacker} from "../src/Attacker.sol";

contract VulnerableVaultTest is Test {

    VulnerableVault public vault;

    // Deploy the contract before each test
    function setUp() public {
        vault = new VulnerableVault();
    }

    // Test 1: Deposit ETH
    function testDeposit() public {
        vm.deal(address(this), 10 ether);

        vault.deposit{value: 1 ether}();

        assertEq(vault.balances(address(this)), 1 ether);
        assertEq(address(vault).balance, 1 ether);
    }

    // Test 2: Withdraw ETH
    function testWithdraw() public {
        vm.deal(address(this), 10 ether);

        vault.deposit{value: 2 ether}();

        vault.withdraw();

        assertEq(vault.balances(address(this)), 0);
        assertEq(address(vault).balance, 0);
    }

    // Test 3: Withdraw without deposit
    function testWithdrawWithoutDeposit() public {
        vm.expectRevert(
            abi.encodeWithSignature(
                "Error(string)",
                "Insufficient balance"
            )
        );

        vault.withdraw();
    }

    // Test 4: Reentrancy Attack
    function testReentrancyAttack() public {
        // Give ETH to the test contract
        vm.deal(address(this), 10 ether);

        // Deploy attacker contract
        Attacker attacker = new Attacker(address(vault));

        // Victim deposits 5 ETH
        vault.deposit{value: 5 ether}();

        // Attacker deposits 1 ETH and starts attack
        attacker.attack{value: 1 ether}();

        // Verify attack result
        assertEq(address(vault).balance, 0);
        assertEq(address(attacker).balance, 6 ether);
    }

    // Allow this test contract to receive ETH
    receive() external payable {}
}
