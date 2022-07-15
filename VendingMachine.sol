// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// custom error

contract VendingMachine {
    address payable owner = payable(msg.sender);

    // error Unothrorized();
    error Unothrorized(address caller);

    function withdraw() public {
        if (msg.sender != owner)
            // tx cost: 23642 gas
            // revert("error");
            // revert Unothrorized();  // tx cost: 23388 gas
            revert Unothrorized(msg.sender); // tx cost: 23591 gas
        
        owner.transfer(address(this).balance);
    }
}