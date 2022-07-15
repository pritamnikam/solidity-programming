// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


// 3 ways to send ETH
// - transfer: 2300 gas, reverts
// - send: 2300 gas, return bool
// - call: all the gas, retun bool and data
contract SendEth {
    constructor() payable {}

    // fallback() external payable {}

    // receive makes it explicit that this contrct will receive  ethers.
    // And in case, any undefined function is called gets error.
    receive() external payable{}

    function sendViaTranser(address payable _to) external payable {
        // sends 2300 gas
        _to.transfer(123);
    }

    // most of the popular smart contracts dont' use send() function
    function sendViaSend(address payable _to) external payable {
        // sends 2300 gas
        bool sent = _to.send(123);
        require(sent, "Send failed.");
    }

    function sendViaCall(address payable _to) external  payable {
        // sends all remaining gas
        (bool success, /*bytes memory data*/) = _to.call{value: 123}("");
        require(success, "call failed.");
    }
}

contract EthReceived {
    event Log(uint amount, uint gas);

    receive() external payable{
        emit Log(msg.value, gasleft());
    }
}