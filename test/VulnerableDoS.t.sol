// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableDoS.sol";
import "../src/DoSAttacker.sol";

contract VulnerableDoSTest is Test {
    VulnerableDoS vulnerable;
    DoSAttacker attacker;

    address alice = makeAddr("alice");

    function setUp() public {
        vulnerable = new VulnerableDoS();
        attacker = new DoSAttacker(address(vulnerable));

        vm.deal(alice, 2 ether);
        vm.deal(address(this), 2 ether);
    }

    function testDenialOfServiceAttack() public {
        // Alice dépose 1 ETH
        vm.prank(alice);
        vulnerable.deposit{value: 1 ether}();

        // Bob effectue son dépôt via le contrat malveillant
        attacker.attack{value: 1 ether}();

        // Vérifier les dépôts
        assertEq(vulnerable.balances(alice), 1 ether);
        assertEq(vulnerable.balances(address(attacker)), 1 ether);

        // La distribution échoue à cause de l'attaquant
        vm.expectRevert(bytes("Payment failed"));
        vulnerable.distribute();

        // Les fonds restent bloqués dans le contrat
        assertEq(address(vulnerable).balance, 2 ether);
        assertEq(vulnerable.balances(alice), 1 ether);
        assertEq(vulnerable.balances(address(attacker)), 1 ether);
    }
}
