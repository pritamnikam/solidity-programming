// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


contract AbiDecode {

    struct MyStruct {
        string name;
        uint[2] nums; 
    }

    function encode(
        uint _x,
        address _caller,
        uint[] calldata _arr,
        MyStruct calldata _myStruct
    )
        external
        pure 
        returns(bytes memory) {
            return abi.encode(_x, _caller, _arr, _myStruct);
    }

    function decode(bytes calldata data)
        external
        pure
        returns (
            uint _x,
            address _caller,
            uint[] memory _arr,
            MyStruct memory _myStruct
        ) {
            (_x, _caller, _arr, _myStruct) = abi.decode(data, (uint, address, uint[], MyStruct));
    }
}