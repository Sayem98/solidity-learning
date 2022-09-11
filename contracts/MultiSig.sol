// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MultiSig{
    address[] public owner;
    mapping(address=>bool) public isOwner;
    uint public ownerCount;
    uint public required;
    uint public txCount;
    struct Transaction{
        address payable to;
        uint value;
        bool executed;
        
    }
    Transaction[] public transactions;
    mapping(uint=>mapping(address=>bool)) public confirmations;

    //Events
    event Deposit(address indexed sender, uint value);
    event NewTransaction(address indexed sender, address indexed to, uint indexed value);
    event Approve(address indexed approver, uint indexed index);
    event Execute(uint indexed index);

    constructor(address[] memory _owners, uint _required){
        require(_required <= _owners.length, 'Required is more than owners');
        require(_required > 0, 'Required is 0');
        require(_owners.length > 0, 'There are no owners');
        
        for(uint i; i<_owners.length;  i++){
            require(_owners[i] !=address(0), 'Owner is the zero address');
            require(!isOwner[_owners[i]], 'Owner is not unique');
            owner.push(_owners[i]);
            isOwner[_owners[i]] = true;



        }
        required = _required;
        
    }

    //modifiers
    
    modifier OnlyOwners(){
        require(isOwner[msg.sender], 'Not owner');
        _;
    }

    modifier trxExists(uint index){
        require(index< transactions.length, 'Trx does not exists.');
        _;
    }
    modifier trxExecuted(uint index){
        Transaction storage transaction = transactions[index];
        require(transaction.executed == false, 'Already executed.');
        _;
    }

    modifier trxApproved(uint index){
        require(confirmations[index][msg.sender] == false,'Already approved');
        _;
    }


    // Receiving Ether sent by other contracts and users
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submitTransaction(address payable _to, uint _value) OnlyOwners trxExists(transactions.length) public {
        transactions.push(Transaction(_to, _value, false));
        emit NewTransaction(msg.sender, _to, _value);

    }

    function ApproveTransaction(uint _index) OnlyOwners trxExists(_index) trxApproved(_index) public{
        confirmations[_index][msg.sender] = true;
        emit Approve(msg.sender, _index);

    }

    function GetApprovalCount(uint _index) public view returns(uint count){
        for(uint i; i<owner.length; i++){
            if(confirmations[_index][owner[i]] == true){
                count++;
            }
        }
    }

    function ExecuteTransacion(uint _index) OnlyOwners trxExists(_index) trxExecuted(_index) external {
        require(GetApprovalCount(_index)>= required, 'Appovel<required');
        Transaction storage transaction = transactions[_index];
        transaction.executed = true;

        transaction.to.transfer(transaction.value);
        emit Execute(_index);



    }
}