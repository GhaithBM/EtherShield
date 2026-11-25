// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SecureSignature.sol";

contract SecureSignatureTest is Test {
    SecureSignature secure;
    uint256 signerPrivateKey = 0xA11CE;
    address signer;
    address alice = makeAddr("alice");

    function setUp() public {
        signer = vm.addr(signerPrivateKey);

        vm.prank(signer);
        secure = new SecureSignature();

        vm.deal(address(secure), 10 ether);
    }

    function testReplayAttackBlocked() public {
        uint256 amount = 1 ether;
        uint256 nonce = 0;

        bytes32 messageHash = keccak256(
            abi.encodePacked(alice, amount, nonce)
        );

        bytes32 ethSignedMessageHash = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                messageHash
            )
        );

        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(signerPrivateKey, ethSignedMessageHash);

        bytes memory signature = abi.encodePacked(r, s, v);

        vm.startPrank(alice);

        // Première utilisation : acceptée
        secure.claim(amount, nonce, signature);

        assertEq(alice.balance, 1 ether);
        assertEq(secure.nonces(alice), 1);

        // Deuxième utilisation : rejetée
        vm.expectRevert(bytes("Invalid nonce"));
        secure.claim(amount, nonce, signature);

        vm.stopPrank();

        assertEq(alice.balance, 1 ether);
        assertEq(address(secure).balance, 9 ether);
    }
}
