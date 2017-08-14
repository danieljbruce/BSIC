pragma solidity ^0.4.2;

contract PiggyBank {
    mapping(address => uint) public balances;

    function PiggyBank(){

    }

    function get(){
        address sender = msg.sender;
        uint sendBalance = balances[msg.sender];
        balances[msg.sender] = 0;
        sender.transfer(sendBalance);
    }

    function () payable {
        // A multiplier 0.98 is needed so that we have enough ether left over to run the code
        if (msg.value > 100000000000000000){ // TODO: change later to reflect gas cost
            balances[msg.sender] = balances[msg.sender] + msg.value;
        }
    }

    function getBalance(address addr) returns (uint) {
        return balances[addr];
    }
}
