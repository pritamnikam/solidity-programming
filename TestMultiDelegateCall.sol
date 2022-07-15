// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


// why use multi delegate call? and not to use multi call?
// alice --> multicall --> call --> test (msg.sender = multi call)
// alice --> test --> delegatecall --> test (msg.sender == alic)
contract MultiDelegateCall {
    error DelegateCallFail();

    function multiDelegateCall(bytes[] calldata data)
        external
        payable
        returns (bytes[] memory results) {

            results = new bytes[](data.length);

            for (uint i = 0; i < data.length; i++) {
                (bool success, bytes memory result) = address(this).delegatecall(data[i]);
                if(!success) revert DelegateCallFail();
                results[i] = result;
            } 
    }
}


contract TestMultiDelegateCall is MultiDelegateCall {
    event Log(address caller, string func, uint i);

    function func1(uint _x, uint _y) external {
        emit Log(msg.sender, "func1", 1);
    }

    function func2() external returns (uint) {
        emit Log(msg.sender, "func2", 2);
        return 111;
    }


    // WARNING!
    // unsafe code when used in combination with multi-delegatcall
    // user can mint multiple times for the price of msg.value

    mapping(address => uint) public balanceOf;

    function mint() external payable {
        balanceOf[msg.sender] += msg.value;
    }
}


contract Helper {
    function getFunc1Data(uint _x, uint _y) external pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegateCall.func1.selector, _x, _y);
    }

    function getFunc2Data() external pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegateCall.func2.selector);
    }

    function getMintData() external pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegateCall.mint.selector);
    }
}
