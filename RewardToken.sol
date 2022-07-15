// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// Simple ERC20 smart contract made for rewards

contract RewardToken is ERC20 {
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol) {
            _mint(msg.sender,
                  1000000 * 10 ** decimals());
        }
}