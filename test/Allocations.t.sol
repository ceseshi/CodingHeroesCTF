// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;


import "forge-std/Test.sol";
import "../src/Allocations.sol";

contract AllocationsTest is Test {
    Allocations public allocations;

    function setUp() public {
        allocations = new Allocations();
    }
}
