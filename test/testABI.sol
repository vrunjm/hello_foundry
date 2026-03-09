// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "forge-std/console2.sol";

contract Counter{
    function count() public pure returns (uint){
        return 1;
    }
}

contract testABI{
    function callCounter(Counter c) public pure{
        console2.log("1111gjmgjm=====================");
        c.count();
        console2.log("1111gjmgjm=====================");

    }

    function lowCallCount(address c) public {
        console2.log("gjmgjm=====================");
        bytes memory methodData = abi.encodeWithSignature("count()");
        (bool success,bytes memory result ) = c.call(methodData);
        uint decodedResult = abi.decode(result, (uint));
        require(success, "Call failed");
        console2.log("Adding value:", decodedResult);

    }
}