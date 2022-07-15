// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SafeMath {
    function testUnderflow() public pure returns(uint) {
        uint x = 0;
        x--;
        return x;
    }

    function testUncheckedUnderflow() public pure returns(uint) {
        uint x = 0;
        unchecked { x--; }
        return x;
    }
}