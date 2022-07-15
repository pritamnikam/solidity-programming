// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ViewAndPureFunction {
    uint public num;

    function viewFun() external view returns (uint) {
        return num;
    }

    function pureFun() external pure returns (uint) {
        return 1;
    }

    function addToNum(uint n) external view returns (uint) {
        return num + n;
    }

    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }
}