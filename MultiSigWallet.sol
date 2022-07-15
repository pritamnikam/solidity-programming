// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract MultiSigWallet {
    // Events
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owners required.");
        require(_required > 0 && _required <= _owners.length, "invalid required number of owners.");

        for (uint i = 0; i <_owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "invalid owner.");
            require(!isOwner[owner], "owner is not unique.");

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not a owner.");
        _;
    }

    modifier txExists(uint _txId) {
        require(transactions.length > _txId, "Invalid transaction.");
        _;
    }

    modifier notApproved(uint _txId) {
        require(!approved[_txId][msg.sender], "Transaction already approved.");
        _;
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "transaction already executed.");
        _;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({
            to: _to, value: _value, data: _data, executed: false
        }));

        emit Submit(transactions.length - 1);
    }

    function approve(uint _txId)
        external 
        onlyOwner 
        txExists(_txId)
        notApproved(_txId)
        notExecuted(_txId) {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function execute(uint _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId) {
            require(_getApprovalCount(_txId) >= required, "approvals < required");
            Transaction storage transaction = transactions[_txId];
            transaction.executed = true;

            (bool success, ) = transaction.to.call{
                value: transaction.value
                }(transaction.data);
            
            require(success, "tx failed.");
            emit Execute(_txId);
    }

    function revoke(uint _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId) {
            require(approved[_txId][msg.sender], "tx not approved.");
            approved[_txId][msg.sender] = false;

            emit Revoke(msg.sender, _txId);
    }


    // helper private functions
    function _getApprovalCount(uint _txId) private view returns (uint count) {
        for (uint i = 0; i < owners.length; i++) {
            if (approved[_txId][owners[i]]) {
                count += 1;
            }
        }
    }
}