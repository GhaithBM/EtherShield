// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableDoS {
    address[] public users;
    mapping(address => uint256) public balances;

    function deposit() external payable {
        require(msg.value > 0, "Send ETH");

        if (balances[msg.sender] == 0) {
            users.push(msg.sender);
        }

        balances[msg.sender] += msg.value;
    }

    function distribute() external {
        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            uint256 amount = balances[user];

            if (amount > 0) {
                (bool success, ) = payable(user).call{value: amount}("");
                require(success, "Payment failed");

                balances[user] = 0;
            }
        }
    }
}
