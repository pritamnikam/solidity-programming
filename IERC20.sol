// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address receipent, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address receipent, uint amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed sender, uint amount);
}
