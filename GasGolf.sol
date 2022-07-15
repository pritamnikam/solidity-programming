// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract GasGolf {
    // start - 50970 gas
    // use calldata - 49141 gas
    // load state variables to memory - 48930 gas
    // short circuit - 48763 gas
    // loop increments - 48403 gas
    // cache array length - 48368 gas
    // load array elements to memory - 48055 gas

    uint public total;

    // [1,2,3,4,5,100]
    function sumIfEventAndLessThan99(uint[] calldata nums) external {
        uint _total = total;
        uint length =  nums.length;
        for (uint i = 0; i < length; i++) {
            uint num = nums[i];
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
        }

        total = _total;
    }
}