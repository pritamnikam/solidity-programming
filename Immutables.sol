// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// immutable variables are contants and 
// can be initialized only once when contract is deployed.

contract Immutables {
    // gas: 43585
    // address public immutable owner = msg.sender;
    address public immutable owner; // can be initialize inside a constructor

    // gas: 45718
    // address public owner = msg.sender;

    uint public x;

    constructor() {
        owner = msg.sender;
    }

    function foo() external {
        require(msg.sender == owner);
        x += 1;
    }
}