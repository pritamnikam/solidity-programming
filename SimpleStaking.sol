// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

contract SimpleStacking {

    // reentrency
    bool internal locked;

    // Library usage
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    // Contract owner
    address public owner;

    // Timestamp related variables
    uint256 public initialTimestamp;
    uint256 public timePeriod;
    bool public timestampSet; 

    // Token amount variables
    mapping(address => uint256) public alreadyWithdrawn;
    mapping(address => uint256) public balances;
    uint256 public contractBalance;

    // ERC20 contract address
    IERC20 public erc20Contract;

    // Events
    event tokensStaked(address from, uint256 amount);
    event TokensUnstaked(address to, uint256 amount);

    // Errors:
    error NoTimePeriodElapsed();

    // Modifiers:
    modifier onlyOwner() {
        require(msg.sender == owner, "Message sender must be the contract's owner.");
        _;
    }

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    modifier timestampNotSet() {
        require(!timestampSet, "The time stamp has already been set.");
        _;
    }

    modifier timestampIsSet() {
        require(timestampSet, "Please set the time stamp first, then try again.");
        _;
    }

    /// @dev Deploys contract and links the ERC20 token which we are staking, also sets owner as msg.sender and sets timestampSet bool to false.
    /// @param _erc20_contract_address.
    constructor(IERC20 _erc20_contract_address) {
        owner = msg.sender;

        require(address(_erc20_contract_address) != address(0),
            "_erc20_contract_address address can not be zero");

        erc20Contract = _erc20_contract_address;
        locked = false;
    }

    /// @dev Sets the initial timestamp and calculates minimum staking period in seconds i.e. 3600 = 1 hour
    /// @param _timePeriodInSeconds amount of seconds to add to the initial timestamp i.e. we are essemtially creating the minimum staking period here
    function setTimestamp(uint256 _timePeriodInSeconds) public onlyOwner timestampNotSet  {
        initialTimestamp = block.timestamp;
        timePeriod = initialTimestamp.add(_timePeriodInSeconds);
        timestampSet = true;
    }

    /// @dev Allows the contract owner to allocate official ERC20 tokens to each future recipient (only one at a time).
    /// @param token, the official ERC20 token which this contract exclusively accepts.
    /// @param amount to allocate to recipient.
    function stakeTokens(IERC20 token, uint256 amount) public timestampIsSet noReentrant {
        require(token == erc20Contract,
            "You are only allowed to stake the official erc20 token address which was passed into this contract's constructor.");

        require(amount <= token.balanceOf(msg.sender),
            "Not enough STATE tokens in your wallet, please try lesser amount");

        token.safeTransferFrom(msg.sender, address(this), amount);
        
        balances[msg.sender] = balances[msg.sender].add(amount);
        emit tokensStaked(msg.sender, amount);
    }

    /// @dev Allows user to unstake tokens after the correct time period has elapsed
    /// @param token - address of the official ERC20 token which is being unlocked here.
    /// @param amount - the amount to unlock (in wei)
    function unstakeTokens(IERC20 token, uint256 amount) public timestampIsSet noReentrant {
        require(token == erc20Contract,
            "You are only allowed to stake the official erc20 token address which was passed into this contract's constructor.");

        require(balances[msg.sender] >= amount,
            "Insufficient token balance, try lesser amount");

        if (block.timestamp >= timePeriod) {
            alreadyWithdrawn[msg.sender] = alreadyWithdrawn[msg.sender].add(amount);
            balances[msg.sender] = balances[msg.sender].sub(amount);

            token.safeTransfer(msg.sender, amount);
            emit TokensUnstaked(msg.sender, amount);
        } else {
            // revert("Tokens are only available after correct time period has elapsed");
            revert NoTimePeriodElapsed();
        }
    }

    /// @dev Transfer accidentally locked ERC20 tokens.
    /// @param token - ERC20 token address.
    /// @param amount of ERC20 tokens to remove.
    function transferAccidentallyLockedTokens(IERC20 token, uint256 amount) public onlyOwner noReentrant {
        require(address(token) != address(0),
            "Token address can not be zero");

        require(token == erc20Contract,
            "You are only allowed to stake the official erc20 token address which was passed into this contract's constructor.");
        
        // Transfer the amount of the specified ERC20 tokens, to the owner of this contract
        token.safeTransfer(owner, amount);
    }
}