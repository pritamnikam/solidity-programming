// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract PiggyBank {
    address public owner = msg.sender;

    // Events:
    event Deposit(uint amount);
    event Withdraw(uint amount);

    receive() external payable {
        emit Deposit(msg.value);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not a owner.");
        _;
    }

    function withdraw() external onlyOwner {
        emit Withdraw(address(this).balance);
        selfdestruct(payable(owner));
    }
}