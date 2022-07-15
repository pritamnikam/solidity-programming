// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// payable keywords allows functionality to send and receive ethers

contract Payable {

    // we can also make address payable
    // by declaring it payable, owner can now send ether
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    // allows to send ether
    function deposit() external payable { }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}