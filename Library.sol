// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

library Math {
    function max(uint x, uint y) internal pure returns (uint) {
        return x >= y ? x : y;
    }
}

contract Test {
    function testMax(uint _x, uint _y) external pure returns (uint) {
        return Math.max(_x, _y);
    }
}


library ArrayLib {
    function find(uint[] storage arr, uint num) internal view returns (uint) {
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] == num) return i;
        }

        revert("not found.");
    }
}

// Enhancing function on data types using library
contract TestArray {
    using ArrayLib for uint[];
    uint[] public nums = [3,2,1];
    function testFind() external view returns (uint i) {
        // return ArrayLib.find(nums, 2);
        return nums.find(2);
    }
}