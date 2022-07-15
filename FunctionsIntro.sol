// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract FunctionsIntro {
    function add(uint a, uint b) external pure returns(uint) {return a+b;}
    function sub(uint a, uint b) external pure returns(uint) {return a-b;}
}