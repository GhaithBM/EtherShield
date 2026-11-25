
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableVault.sol";

contract VaultHandler is Test {
    VulnerableVault vault;

    constructor(VulnerableVault _vault) {
        vault = _vault;
    }

    function deposit(uint256 amount) public {
        amount = bound(amount, 1 wei, 10 ether);

        vm.deal(address(this), amount);

        vault.deposit{value: amount}();
    }

    receive() external payable {}
}

contract InvariantTesting is Test {
    VulnerableVault vault;
    VaultHandler handler;

    function setUp() public {
        vault = new VulnerableVault();
        handler = new VaultHandler(vault);

        targetContract(address(handler));
    }

    function invariant_balanceNeverNegative() public view {
        assertGe(address(vault).balance, 0);
    }
}
