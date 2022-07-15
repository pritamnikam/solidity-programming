// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// Events allows you to write data on blockchain
// These data cannot be later retrived by smart contract 
// The main purpose of events is to log that something is happened 
// so it can be cheap alternative to storing data as the state variables

contract Event {
    event Log(string message, uint value);

    // up to 3 params can be index
    event IndexedLog(address indexed sender, uint value);

    function example() external {
        emit Log("foo", 123);

        emit IndexedLog(msg.sender, 1234);
    }

    // Anyone having the access to the blockchain will be able to see the message.
    event Message(address indexed _from, address indexed _to, string _message);

    function sendMessage(address _to, string calldata _message) external {
        emit Message(msg.sender, _to, _message);
    }

}