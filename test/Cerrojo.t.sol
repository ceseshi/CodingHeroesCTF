// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;


import "forge-std/Test.sol";
import "../src/Cerrojo.sol";

contract CerrojoTest is Test {
    Cerrojo public cerrojo;

    function setUp() public {
        cerrojo = new Cerrojo();
    }

}
