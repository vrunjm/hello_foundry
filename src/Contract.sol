pragma solidity ^0.8.13;

contract Contract {
    uint public counter;

    function MyTrasfer(address payable to ) public view returns (uint){
        if to.balance>10 && address(this).balance<=10{
            x.transfer(1 wei);
        }
    }



    constructor() public payable{
        counter = 0;
    }

    function add() public {
        counter += 1;
    }

    function subtract() public {
        counter -= 1;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}
