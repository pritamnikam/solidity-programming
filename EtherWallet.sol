// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract EtherWallet {
    address payable public owner;

    modifier onlyOwner {
        require(msg.sender == owner, "Only owners are allowed to call.");
        _;
    }

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable { }

    function withdraw(uint _amount) external onlyOwner {
        // state variables consume more gas
        // owner.transfer(_amount);

        payable(msg.sender).transfer(_amount);

/*
        // alternatively we can use call()
        (bool sent, ) = payable(msg.sender).call{value: _amount}("");
        require(sent, "call failed");
*/
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}