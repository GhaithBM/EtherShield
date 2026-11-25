
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableVault.sol";

contract FuzzTesting is Test {
    VulnerableVault vault;

    function setUp() public {
        vault = new VulnerableVault();
    }

    function testFuzz_Deposit(uint256 amount) public {
        amount = bound(amount, 1 wei, 100 ether);

        vm.deal(address(this), amount);

        vault.deposit{value: amount}();

        assertEq(address(vault).balance, amount);
    }

    receive() external payable {}
}
