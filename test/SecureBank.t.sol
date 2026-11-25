// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SecureBank.sol";

contract SecureBankTest is Test {

    SecureBank bank;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        vm.prank(alice);
        bank = new SecureBank();
    }

    function testUnauthorizedOwnerChangeBlocked() public {

        // Alice is the initial owner
        assertEq(bank.owner(), alice);
        assertEq(bank.currentOwner(), alice);

        // Bob tries to change the owner
        vm.prank(bob);
        vm.expectRevert();

        bank.changeOwner(bob);

        // Bob must not become the owner
        assertEq(bank.owner(), alice);
        assertEq(bank.currentOwner(), alice);
    }

    function testOwnerCanChangeOwner() public {

        // Alice is authorized to change the owner
        vm.prank(alice);
        bank.changeOwner(bob);

        assertEq(bank.owner(), alice);
        assertEq(bank.currentOwner(), bob);
    }
}
