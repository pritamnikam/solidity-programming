// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// order of inheritance -> most base-like to derived

contract X {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }

    function bar() public pure virtual returns (string memory) {
        return "A";
    }

    function x() external pure returns  (string memory) {
        return "A";
    }
}

contract Y is X {
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }

    function bar() public pure virtual override returns (string memory) {
        return "B";
    }

    function y() external pure returns  (string memory) {
        return "B";
    }
}

contract Z is X, Y {
    function foo() public pure override(X, Y) returns (string memory) {
        return "C";
    }

    function bar() public pure override(Y, X) returns (string memory) {
        return "C";
    }
}