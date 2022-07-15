// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/*
Fallback execution when 
- function doesn't exist
- directly send ETH
*/


/*
fallback or receive

        Ether is sent to contract
                    |
            is msg.data is empty?
                   / \
                yes   No
                /      \
    receive() exists?   fallback()
           / \          
        yes   no
        /      \
    receive()  fallback()
*/


contract Fallback {

    event Log(string func, address sender, uint value, bytes data);

    // calling a function that does not exist
    // place payable keyword to receive ethers 
    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }
}