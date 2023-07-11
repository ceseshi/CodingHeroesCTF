// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;


import "forge-std/Test.sol";
import "../src/Vault2.sol";

contract Vault2Test is Test {
    Vault2 public vault;

    function setUp() public {
        vault = new Vault2{value: 0.0001 ether}();
    }
}
