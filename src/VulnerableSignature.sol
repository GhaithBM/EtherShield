// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableSignature {
    address public signer;
    mapping(address => uint256) public balances;

    constructor() {
        signer = msg.sender;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function claim(
        uint256 amount,
        bytes memory signature
    ) external {
        bytes32 messageHash = keccak256(
            abi.encodePacked(msg.sender, amount)
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

        payable(msg.sender).transfer(amount);
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
}
