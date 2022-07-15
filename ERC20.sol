// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint public override totalSupply;
    mapping(address => uint) public override balanceOf;
    mapping(address => mapping(address => uint)) public override allowance;

    string public name = "TEST";
    string public symbol = "TEST";
    uint8 public decimals = 18;

    
    function transfer(address receipent, uint amount) external override returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[receipent] += amount;

        emit Transfer(msg.sender, receipent, amount);
        return true;
    }
    
    function approve(address spender, uint amount) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address receipent, uint amount) external override returns (bool) {
        allowance[sender][msg.sender] -= amount;

        balanceOf[sender] -= amount;
        balanceOf[receipent] += amount;

        emit Transfer(sender, receipent, amount);
        return true;
    }

    // these functuns are not part of ERC20 standard but often used
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;

        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }
}