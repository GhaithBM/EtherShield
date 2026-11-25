// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableBank.sol";

contract VulnerableBankTest is Test {

    VulnerableBank bank;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        // Alice deploys the bank
        vm.prank(alice);
        bank = new VulnerableBank();
    }

    function testUnauthorizedOwnerChange() public {

        // Alice is initially the owner
        assertEq(bank.owner(), alice);

        // Bob changes the owner without permission
        vm.prank(bob);
        bank.changeOwner(bob);

        // Verify that Bob became the owner
        assertEq(bank.owner(), bob);
    }
}
