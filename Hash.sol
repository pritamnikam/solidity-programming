// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract HashFunc {
    function hash(string memory _text,
                  uint _num,
                  address _addr) external pure returns (bytes32) {
        return keccak256(
            abi.encodePacked(_text, _num, _addr)
        );
    }


    function encode(string memory text1,
                    string memory text2) external pure returns (bytes memory) {
        return abi.encode(text1, text2);
    }

    function encodePacked(string memory text1,
                          string memory text2) external pure returns (bytes memory) {
        return abi.encodePacked(text1, text2);
    }
}