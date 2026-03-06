// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract Contract {
    uint public counter;

    function add() public {
        counter += 1;
    }
}
