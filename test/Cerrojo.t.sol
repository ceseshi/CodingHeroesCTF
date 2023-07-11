// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;


import "forge-std/Test.sol";
import "../src/Cerrojo.sol";

contract CerrojoTest is Test {
    Cerrojo public cerrojo;

    function setUp() public {
        cerrojo = new Cerrojo{value: 1 ether}();
    }

    function testCerrojo() public {

        cerrojo.pick1(uint256(420));
        cerrojo.pick2{value: 33}();
        cerrojo.pick3(bytes16(bytes2(0x6942)));
        cerrojo.recoverFunds();
    }
}
