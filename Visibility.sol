// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


/*
Visibility
Functions and state variables have to declare whether they are accessible by other contracts.

Functions can be declared as
public - any contract and account can call
private - only inside the contract that defines the function
internal- only inside contract that inherits an internal function
external - only other contracts and accounts can call

State variables can be declared as public, private, or internal but not external.
*/

contract VisibilityBase {
    uint private x = 0;
    uint internal y = 1;
    uint public z = 2;

    function privateFunction() private pure returns (uint) {

    }

    function internalFunction() internal pure returns (uint) {

    }

    function publicFunction() public pure returns (uint) {

    }

    function externalFunction() external view {

    }


    function examples() external view {
        x + y + z;

        privateFunction();
        internalFunction();
        publicFunction();

        // externalFunction();  //<- error
        this.externalFunction();  // hack and gas inefficient
    }
}

contract ChildContract is VisibilityBase {
    function examples2() external view {
        y + z;

        internalFunction();
        publicFunction();

        // privateFunction(); // error
        // externalFunction();  // error
    }
}