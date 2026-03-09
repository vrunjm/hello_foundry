pragma solidity ^0.8.13;

contract Contract {
    uint public counter;

    // 修复：1. 移除 view 修饰符 2. 修正变量x为to 3. if条件加() 4. 补充返回值 5. 修复转账逻辑
    function MyTransfer(address payable to) public payable returns (uint) {
        // 修复：if条件必须用()包裹
        if (to.balance > 10 && address(this).balance <= 10) {
            // 修复1：变量x未定义 → 改为to
            // 修复2：transfer有gas限制，改用call更安全
            (bool success, ) = to.call{value: 1 wei}("");
            require(success, "Transfer failed");
        }
        // 修复：补充返回值（声明返回uint，必须return）
        return address(this).balance;
    }

    // 修复：Solidity 0.8.0+ 构造函数无需public修饰符
    constructor() payable {
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