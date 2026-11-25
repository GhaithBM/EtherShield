// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureSignature {
    address public signer;

    mapping(address => uint256) public nonces;

    constructor() {
        signer = msg.sender;
    }

    function claim(
        uint256 amount,
        uint256 nonce,
        bytes memory signature
    ) external {
        require(nonce == nonces[msg.sender], "Invalid nonce");

        bytes32 messageHash = keccak256(
            abi.encodePacked(msg.sender, amount, nonce)
        );

        bytes32 ethSignedMessageHash = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                messageHash
            )
        );

        (bytes32 r, bytes32 s, uint8 v) = splitSignature(signature);

        address recovered = ecrecover(
            ethSignedMessageHash,
            v,
            r,
            s
        );

        require(recovered == signer, "Invalid signature");
        require(address(this).balance >= amount, "Insufficient funds");

        nonces[msg.sender]++;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function splitSignature(bytes memory sig)
        internal
        pure
        returns (bytes32 r, bytes32 s, uint8 v)
    {
        require(sig.length == 65, "Invalid signature length");

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    receive() external payable {}
}
