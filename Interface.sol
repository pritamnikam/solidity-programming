// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface IConter {
    function count() external view returns (uint);
    function increment() external;
    function decrement() external;
}

contract CallInterface {
    uint public count;
    function examples(address _counter) external {
        IConter(_counter).increment();
        count = IConter(_counter).count();
    } 
}