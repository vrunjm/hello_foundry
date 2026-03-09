// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 直接引用 OpenZeppelin 的 ERC20 合约（路径以 @openzeppelin 开头）
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 自定义 ERC20 代币合约，继承 OpenZeppelin 的 ERC20
contract MyToken is ERC20 {
    // 构造函数：初始化代币名称和符号
    constructor() ERC20("MyToken", "MT") {
        // 给部署者铸造 1000 个代币（注意：ERC20 有小数位，默认 18 位）
        _mint(msg.sender, 1000 * 10 ** decimals());
    }
}