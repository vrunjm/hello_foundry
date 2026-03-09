// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "hardhat/console.sol";

contract Counter{
    function count() public pure returns (uint){
        return 1;
    }
}

contract testABI{
    function callCounter(Counter c) public pure{
        console.log("1111gjmgjm=====================");
        c.count();
        console.log("1111gjmgjm=====================");

    }

    function lowCallCount(address c) public {
        console.log("gjmgjm=====================");
        bytes memory methodData = abi.encodeWithSignature("count()");
        (bool success,bytes memory result ) = c.call(methodData);
        uint decodedResult = abi.decode(result, (uint));
        require(success, "Call failed");
        console.log("Adding value:", decodedResult);

    }
}