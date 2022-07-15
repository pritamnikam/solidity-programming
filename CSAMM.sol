// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./IERC20.sol";

// Sample contract for "Constant Sum Automatic Market Makers (CSAMM)".
contract CSAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;  // blanace of token0
    uint public reserve1;  // blanace of token1

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        totalSupply += _amount;
        balanceOf[_to] += _amount;
    }

    function _burn(address _from, uint _amount) private {
        totalSupply -= _amount;
        balanceOf[_from] -= _amount;
    }

    function _update(uint _res0, uint _res1) private {
        reserve0 = _res0;
        reserve1 = _res1;
    }

    function swap(
        address _tokenIn,
        uint _amountIn
    )
        external
        returns (uint amountOut) {
            require(_tokenIn == address(token0) || _tokenIn == address(token1),
                "Invalid token."
            );

            // Optimized by refactor
            bool isToken0 = (_tokenIn == address(token0));
            (IERC20 tokenIn, IERC20 tokenOut, uint resIn, uint resOut) = isToken0 ?
                (token0, token1, reserve0, reserve1) :
                (token1, token0, reserve1, reserve0);

            // 1. transfer token in
            tokenIn.transferFrom(msg.sender, address(this), _amountIn);
            uint amountIn = tokenIn.balanceOf(address(this)) - resIn;

            // 2. calculate amount ount (including fees)
            // dx = dy
            // 0.3% fee trading
            amountOut = (amountIn * 997) / 1000;

            // 3. update reserve0 & reserve1
            (uint res0, uint res1) = isToken0 ?
                (resIn + _amountIn, resOut - amountOut) :
                (resOut - amountOut, resIn + _amountIn);

            _update(res0, res1);
            
            // 4. transfer token out
            tokenOut.transfer(msg.sender, amountOut);
    }

    function addLiquidity(
        uint _amount0, 
        uint _amount1
    )
        external
        returns (uint shares) {
            token0.transferFrom(msg.sender, address(this), _amount0);
            token1.transferFrom(msg.sender, address(this), _amount1);

            uint balance0 = token0.balanceOf(address(this));
            uint balance1 = token1.balanceOf(address(this));

            uint amountIn0 = balance0 - reserve0;
            uint amountIn1 = balance1 - reserve1;

        /*
            a = amount
            B = balance of token before deposit
            T = total supply
            s = shares to mint

            (T + s) / T = (a + B) / B
            s = aT / B; 
        */

        if (totalSupply == 0) {
            shares = amountIn0 + amountIn1;
        } else {
            shares = ((amountIn0 + amountIn1) * totalSupply) / (reserve0 + reserve1);
        }

        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);
        _update(balance0, balance1);
    }


    function removeLiquidity(
        uint _shares
    )
    external
    returns (uint d0, uint d1) {

        /*
            a = amount
            B = balance of token before deposit
            T = total supply
            s = shares to mint

            (T + s) / T = (a + B) / B
            a = sB / T;
              = (reserve0 + reserve1) * s / T
        */

        d0 = (reserve0 * _shares) / totalSupply;
        d1 = (reserve1 * _shares) / totalSupply;

        _burn(msg.sender, _shares);
        _update(reserve0 - d0, reserve1 - d1);

        if(d0 > 0) {
            token0.transfer(msg.sender, d0);
        }

        if (d1 > 0) {
            token1.transfer(msg.sender, d1);
        }
    }
}

