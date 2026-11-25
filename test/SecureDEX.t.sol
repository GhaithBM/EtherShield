// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SecureDEX.sol";

contract SecureDEXTest is Test {
    SecureDEX dex;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        dex = new SecureDEX();

        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
    }

    function testFrontRunningBlocked() public {
        // Bob achète avant Alice
        vm.prank(bob);
        dex.buy{value: 1 ether}(100);

        // Vérifier que Bob reçoit 100 tokens
        assertEq(dex.tokens(bob), 100);

        // Alice exige au minimum 95 tokens
        vm.prank(alice);
        vm.expectRevert(bytes("Slippage too high"));
        dex.buy{value: 1 ether}(95);

        // La transaction d'Alice est annulée
        assertEq(dex.tokens(alice), 0);
        assertEq(address(dex).balance, 1 ether);
        assertEq(alice.balance, 10 ether);
    }

    function testNormalPurchaseSucceeds() public {
        vm.prank(alice);
        dex.buy{value: 1 ether}(90);

        assertEq(dex.tokens(alice), 100);
    }
}
