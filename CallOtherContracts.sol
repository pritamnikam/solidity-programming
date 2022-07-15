// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract CallTestContract {
    // function setX(address _test, uint _x) external {
    //     // 1. Calling TestContract functions deployed at address |_test|
    //     TestContract(_test).setX(_x);
    // }

    // Alernatively
    function setX(TestContract _test, uint _x) external {
        _test.setX(
            _x
        );
    }

    function getX(TestContract _test) external view returns (uint x) {
        x = _test.getX();
    }

    function setXAndReceiveEthers(TestContract _test, uint _x) external payable {
        _test.setXAndReceiveEthers{value: msg.value}(_x);
    }

    function getXAndValue(TestContract _test) external view returns (uint x, uint value) {
        (x, value) = _test.getXAndValue();
    }
}


contract TestContract {
    uint public x;
    uint public value = 123;

    function setX(uint _x) external {
        x = _x;
    }

    function getX() external view returns (uint) {
        return x;
    }

    function setXAndReceiveEthers(uint _x) external payable {
        x = _x;
        value = msg.value;
    }

    function getXAndValue() external view returns (uint, uint) {
        return (x, value);
    }
}