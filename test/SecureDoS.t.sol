// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SecureDoS.sol";

contract SecureDoSTest is Test {
    SecureDoS secure;

    address alice = makeAddr("alice");

    function setUp() public {
        secure = new SecureDoS();

        vm.deal(alice, 2 ether);
    }

    function testDoSAttackBlocked() public {
        // Alice dépose 1 ETH
        vm.prank(alice);
        secure.deposit{value: 1 ether}();

        // Le contrat malveillant dépose 1 ETH
        // Son adresse ne peut pas recevoir d'ETH
        RefusingReceiver attacker = new RefusingReceiver(secure);

        attacker.attack{value: 1 ether}();

        // Alice peut retirer normalement
        vm.prank(alice);
        secure.withdraw();

        assertEq(alice.balance, 2 ether);
        assertEq(secure.balances(alice), 0);

        // L'attaquant ne peut pas retirer, mais ne bloque pas Alice
        vm.expectRevert(bytes("Withdrawal failed"));
        attacker.withdraw();

        assertEq(address(secure).balance, 1 ether);
        assertEq(secure.balances(address(attacker)), 1 ether);
    }
}

contract RefusingReceiver {
    SecureDoS public target;

    constructor(SecureDoS _target) {
        target = _target;
    }

    function attack() external payable {
        target.deposit{value: msg.value}();
    }

    function withdraw() external {
        target.withdraw();
    }

    receive() external payable {
        revert("I refuse ETH");
    }
}
