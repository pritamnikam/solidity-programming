// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TimeLock {
    address public owner;
    mapping(bytes32 => bool) public queued;

    uint public constant MIN_DELAY = 10;
    uint public constant MAX_DELAY = 1000;
    uint public constant GRACE_PERIOD = 1000;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    error NotOwnerError();
    error AlreadyQueuedError(bytes32 txId);
    error TimestampNotInRangeError(uint blockTimestamp, uint timestamp);
    error NotQueuedError(bytes32 txId);
    error TimestampNotPassedError(uint blockTimestamp, uint timestamp);
    error ExpiredTimePeriodError(uint blockTimestamp, uint expireAt);
    error TxFailedError(bytes32 txId);

    event Queue(
        bytes32 indexed txId,
        address indexed target,
        uint value,
        string func,
        bytes data,
        uint timestamp
    );

    event Execute(
        bytes32 indexed txId,
        address indexed target,
        uint value,
        string func,
        bytes data,
        uint timestamp
    );

    event Cancel(bytes32 indexed txId);

    modifier onlyOwner() {
        if (owner != msg.sender)
            revert NotOwnerError();
        _;
    }

    // broadcast a transaction by calling queue()
    // after defined queue you have to wait for certain amount time in contract before executing
    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) 
        external
        onlyOwner {
            // 1. create tx id
            bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);

            // 2. check if the tx id is unique
            if (queued[txId]) revert AlreadyQueuedError(txId);

            // 3. check timestamp
            // ----|--------------|--------------|----
            //   block      block + min    block + max
            if (
                _timestamp < block.timestamp + MIN_DELAY ||
                _timestamp > block.timestamp + MAX_DELAY
            ) {
                    revert TimestampNotInRangeError(block.timestamp, _timestamp);
            }

            // 4. queue tx
            queued[txId] = true;

            emit Queue(
                txId, _target, _value, _func, _data, _timestamp
            );
    }

    // Once a time has passed then the function execute() can be called to execute the transaction
    function execute(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) 
        external
        payable
        onlyOwner
        returns (bytes memory) {

            // 1. create tx id
            bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);

            // 2. check if the tx id is unique
            if (!queued[txId]) {
                revert NotQueuedError(txId);
            }

            // 3. check timestamp
            if (block.timestamp < _timestamp) {
                revert TimestampNotPassedError(block.timestamp, _timestamp);
            }

            // ----|---------------------------|--------------
            //  timestamp            timestamp + grace period
            if (block.timestamp > _timestamp + GRACE_PERIOD) {
                revert ExpiredTimePeriodError(block.timestamp, _timestamp);
            }

            // 4. delete tx from queue
            queued[txId] = false;
            

            // 5. execute the transaction
            bytes memory data;
            if (bytes(_func).length > 1) {
                data = abi.encodePacked(
                    bytes4(keccak256(bytes(_func))),
                    _data
                );
            } else {
                data = _data;
            }

            (bool ok, bytes memory res) = _target.call{value: _value}(data);
            if (!ok) {
                revert TxFailedError(txId);
            }

            emit Execute(
                txId, _target, _value, _func, _data, _timestamp
            );

            return res;
    }

    function cancel(bytes32 _txId) external {
        if (!queued[_txId]) {
            revert NotQueuedError(_txId);
        }

        queued[_txId] = false;
        emit Cancel(_txId);
    }



    // helper functuns
    function getTxId(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
        ) public pure returns (bytes32 txId) {
            return keccak256(
                abi.encode(_target, _value, _func, _data, _timestamp)
            );
    }
}

contract TestTimeLock {
    address public timeLock;

    constructor(address _timelock) {
        timeLock = _timelock;
    }

    function test() external {
        require(msg.sender == timeLock);

        // more code here
        // - upgrade contract
        // - transfer fund
        // - switch to oracle
    }

    function getTimestamp() external view returns (uint) {
        return block.timestamp + 100;
    }
}