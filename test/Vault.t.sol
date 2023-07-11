// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;


import "forge-std/Test.sol";
import "../src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;

    function setUp() public {
        vault = new Vault{value: 0.0001 ether}();
    }
}
