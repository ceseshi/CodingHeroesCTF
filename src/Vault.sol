//SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

contract Vault {
    // @notice This is the secret number, its value is safe because it's a private variable :P
    uint256 private _secret;

    event FundsRecovered(address indexed sender, uint256 amount);
   constructor() payable {
        require(
            msg.value == 0.0001 ether,
            "You must send 0.0001 ether to create the vault"
        );
        _secret =
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        gasleft()
                    )
                )
            ) %
            31337;
    }

    /// @dev Owner can unlock funds using the secret number
    function recoverFunds(uint256 _password) external payable {
        require(
            msg.value == 0.0001 ether,
            "You must send 0.0001 ether to unlock the funds"
        );

        uint256 _balance = address(this).balance;

        if (
            _password == uint256(keccak256(abi.encodePacked(_secret, _balance)))
        ) {
            payable(msg.sender).transfer(_balance);
            emit FundsRecovered(msg.sender, _balance);
        }

        // Security measure to prevent funds from being stolen
        _secret =
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        gasleft()
                    )
                )
            ) %
            31337;
    }

}