// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableDEX.sol";

contract VulnerableDEXTest is Test {
    VulnerableDEX dex;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        dex = new VulnerableDEX();

        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
    }

    function testFrontRunningAttack() public {
        // Alice veut acheter avec 1 ETH
        uint256 aliceInitialPrice = dex.tokenPrice();

        // Bob passe avant Alice et achète avec 1 ETH
        vm.prank(bob);
        dex.buy{value: 1 ether}();

        // Le prix augmente
        assertGt(dex.tokenPrice(), aliceInitialPrice);

        // Alice achète ensuite avec 1 ETH
        vm.prank(alice);
        dex.buy{value: 1 ether}();

        // Bob reçoit plus de tokens qu'Alice
        assertEq(dex.tokens(bob), 100);
        assertEq(dex.tokens(alice), 90);

        assertGt(dex.tokens(bob), dex.tokens(alice));
    }
}
