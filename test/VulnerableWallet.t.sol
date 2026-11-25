// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableWallet.sol";
import "../src/MaliciousContract.sol";

contract VulnerableWalletTest is Test {

    VulnerableWallet wallet;
    MaliciousContract malicious;

    address alice = makeAddr("alice");

    function setUp() public {

        // Alice deploys the wallet
        vm.prank(alice, alice);
        wallet = new VulnerableWallet();

        // Fund the wallet with 5 ETH
        vm.deal(address(wallet), 5 ether);

        // Deploy malicious intermediary
        malicious = new MaliciousContract(address(wallet));
    }

    function testTxOriginAttack() public {

        assertEq(wallet.owner(), alice);
        assertEq(address(wallet).balance, 5 ether);

        // Alice calls the malicious contract
        vm.prank(alice, alice);
        malicious.attack();

        // The malicious contract receives the funds
        assertEq(address(wallet).balance, 0);
        assertEq(address(malicious).balance, 5 ether);
    }
}
