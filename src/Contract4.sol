pragma solidity ^0.8.0;

contract ABIEncoder {
    function encodeUint(uint256 value) public pure returns (bytes memory) {
        //
        return abi.encode(value);
    }

    function encodeMultiple(
        uint num,
        string memory text
    ) public pure returns (bytes memory) {
       //
       return abi.encode(num, text);
    }
}

contract ABIDecoder {
    function decodeUint(bytes memory data) public pure returns (uint) {
        //
        return decodedValue;
    }

    function decodeMultiple(
        bytes memory data
    ) public pure returns (uint, string memory) {
        //
        (uint256 decodedNum, string memory decodedText) = abi.decode(data, (uint256, string));
        return (decodedNum, decodedText);
    }
}