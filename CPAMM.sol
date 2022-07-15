// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./IERC20.sol";

// Sample contract for "Constant Product Automatic Market Makers (CSAMM)".
contract CPAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;


    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }


    function _mint(address _account, uint _amount) private {
        balanceOf[_account] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _account, uint _amount) private {
        balanceOf[_account] -= _amount;
        totalSupply -= _amount;
    }

    function _update(uint _res0, uint _res1) private {
        reserve0 = _res0;
        reserve1 = _res1;
    }

    function _sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _min(uint _x, uint _y) private pure returns (uint) {
        return  (_x <= _y) ? _x : _y;
    }

    function swap(address _tokenIn, uint _amountIn) external returns (uint amountOut) {
        require(
            _tokenIn == address(token0) ||
            _tokenIn == address(token1),
            "Invalid token."
        );

        require(_amountIn > 0, "Invalid token amount.");

        bool isToken0 = _tokenIn == address(token0);

        (IERC20 tokenIn, IERC20 tokenOut, uint resIn, uint resOut) = isToken0 ?
            (token0, token1, reserve0, reserve1) :
            (token1, token0, reserve1, reserve0);

        // 1. pull in token in
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);

        // 2. Calculate token out (including fee), fee: 0.3%
        // dy = (y * dx) / (x + dx)

        uint amountInWithFee = (_amountIn * 997) / 1000;
        amountOut = (resOut * amountInWithFee) / (resIn + amountInWithFee);

        // 3. Transfer tokens out to the msg.sender
        tokenOut.transfer(msg.sender, amountOut);

        // 4. update the reserves: reserve0 & reserve1
        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );        
    }

    function addLiquidity(
        uint _amount0,
        uint _amount1
    )
        external
        returns (uint shares) {
            // 1. pull in tokens
            token0.transferFrom(msg.sender, address(this), _amount0);
            token1.transferFrom(msg.sender, address(this), _amount1);

            // dy / dx = y / x
            if (reserve0 > 0 && reserve1 > 0) {
                require (
                    reserve0 * _amount1 == reserve1 * _amount0,
                    "dy/dx != y/x"
                );
            }

            // 2. mint shares
            // f(x, y) = value of liquidity = sqrt(yx)
            // s = dx / x * T = dy / y * T
            if (totalSupply == 0) {
                shares = _sqrt(_amount0 * _amount1);
            } else {
                shares = _min(
                    (_amount0 * totalSupply) / reserve0,
                    (_amount1 * totalSupply) / reserve1
                );
            }

            require(shares > 0, "shares less than zero.");
            _mint(msg.sender, shares);

            // 3. update reserves
            _update(
                token0.balanceOf(address(this)),
                token1.balanceOf(address(this))
            ); 
    }

    function removeLiquidity(
        uint _shares
    )
        external
        returns (uint amount0, uint amount1) {
            // 1. calculate amount0 and amount1 to withdraw
            // dx = s * T / x
            // dy = s * T / y
            uint bal0 = token0.balanceOf(address(this));
            uint bal1 = token1.balanceOf(address(this));
            
            amount0 = (_shares * bal0) / totalSupply;
            amount1 = (_shares * bal1) / totalSupply;
            require (amount0 > 0 && amount1 > 0, "amounts are zero");

            // 2. burn shares
            _burn(msg.sender, _shares);

            // 3. update the reserves
            _update(
                bal0 - amount0,
                bal1 - amount1
            );

            // 4. transfer amounts to msg.sender
            token0.transfer(msg.sender, amount0);
            token1.transfer(msg.sender, amount1);
    }
}
