// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// 2 ways to call parent constructor
// Order of initialization

contract S {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract T {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

contract U is S("s"), T("t") { }

contract V1 is S, T {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {}
}

contract V2 is S, T {
    constructor(string memory _name, string memory _text) T(_text) S(_name)  {}
}