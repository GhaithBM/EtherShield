// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SecureWallet.sol";
import "../src/MaliciousContract.sol";

contract SecureWalletTest is Test {
    SecureWallet wallet;
    MaliciousContract malicious;
    address alice = makeAddr("alice");

    function setUp() public {
        vm.prank(alice);
        wallet = new SecureWallet();

        vm.deal(address(wallet), 5 ether);
        malicious = new MaliciousContract(address(wallet));
    }

    function testTxOriginAttackBlocked() public {
        assertEq(wallet.owner(), alice);
        assertEq(address(wallet).balance, 5 ether);

        vm.expectRevert(bytes("Not owner"));
        vm.prank(alice, alice);
        malicious.attack();

        assertEq(address(wallet).balance, 5 ether);
        assertEq(address(malicious).balance, 0);
    }
}
