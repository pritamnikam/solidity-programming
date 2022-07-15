// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract VariableTypes {
    uint public a = 1;
    int public b = -1;
    bool public bo = true;

    address public ad = 0x9d83e140330758a8fFD07F8Bd73e86ebcA8a5692;
    bytes32 public ad2 = 0x324c6bb2dd4e1dcdb24f60bdfb79822e9e93a36fcdc6710adb847bbdd87ed6ba;
}

contract StableVariable {
    // state variables stored on blockchain
    uint public myUint = 123;

    function foo() public pure {
        // inside function are local variables
        // exist inside only function
        uint notStateVariable = 123;
        notStateVariable++;
    }
}

contract LocalVariable {
    uint public i;
    bool public b;
    address public myAddress;

    function foo() external {
        uint x = 123;
        bool f = false;

        // more code
        x += 456;
        f = true;

        i = x;
        b = f;
        myAddress = address(1);
    }
}

contract GlobalVariables {
    function globalVariables() external view returns (address, uint, uint) {
        address sender = msg.sender;
        uint timestamp = block.timestamp;
        uint blockNumber = block.number;
        return (sender, timestamp, blockNumber);
    }
}