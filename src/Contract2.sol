// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Bank 合约
 * @dev 实现存款、管理员提款、记录存款前3名用户功能
 */
contract Bank {
    // 管理员地址
    address private immutable _owner;
    
    // 记录每个地址的存款金额
    mapping(address => uint256) public balances;
    
    // 存储存款前3名用户的结构体
    struct TopDepositor {
        address user;
        uint256 amount;
    }
    
    // 存款前3名用户数组（按金额降序排列）
    TopDepositor[3] public topDepositors;

    // 事件声明
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed admin, uint256 amount);
    event TopDepositorsUpdated(address[3] users, uint256[3] amounts);

    // 修饰器：仅管理员可调用
    modifier onlyOwner() {
        require(msg.sender == _owner, "Bank: only owner can call this function");
        _;
    }

    // 构造函数：部署合约时设置管理员为部署者
    constructor() {
        _owner = msg.sender;
    }

    /**
     * @dev 接收ETH的回退函数（支持直接向合约地址转账）
     * @notice 向合约存款，会自动记录余额并更新前3名
     */
    receive() external payable {
        _deposit();
    }

    /**
     * @dev 备用回退函数（防止调用不存在的函数时ETH丢失）
     */
    fallback() external payable {
        _deposit();
    }

    /**
     * @dev 内部存款处理逻辑
     */
    function _deposit() internal {
        require(msg.value > 0, "Bank: deposit amount must be greater than 0");
        
        // 更新用户余额
        balances[msg.sender] += msg.value;
        
        // 更新存款前3名
        _updateTopDepositors(msg.sender, balances[msg.sender]);
        
        // 触发存款事件
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * @dev 管理员提取合约资金
     * @param amount 提取的金额（单位：wei）
     */
    function withdraw(uint256 amount) external onlyOwner {
        require(amount > 0, "Bank: withdraw amount must be greater than 0");
        require(address(this).balance >= amount, "Bank: insufficient contract balance");
        
        // 转账给管理员（使用call防止重入攻击）
        (bool success, ) = _owner.call{value: amount}("");
        require(success, "Bank: withdraw failed");
        
        emit Withdrawn(_owner, amount);
    }

    /**
     * @dev 更新存款前3名用户
     * @param user 存款用户地址
     * @param amount 用户当前存款总额
     */
    function _updateTopDepositors(address user, uint256 amount) internal {
        // 检查当前用户是否能进入前3
        for (uint256 i = 0; i < 3; i++) {
            if (amount > topDepositors[i].amount) {
                // 向后移动排名靠后的用户
                for (uint256 j = 2; j > i; j--) {
                    topDepositors[j] = topDepositors[j-1];
                }
                // 插入当前用户到对应位置
                topDepositors[i] = TopDepositor(user, amount);
                break;
            }
        }

        // 触发排名更新事件
        address[3] memory topUsers;
        uint256[3] memory topAmounts;
        for (uint256 i = 0; i < 3; i++) {
            topUsers[i] = topDepositors[i].user;
            topAmounts[i] = topDepositors[i].amount;
        }
        emit TopDepositorsUpdated(topUsers, topAmounts);
    }

    /**
     * @dev 获取合约当前总余额
     * @return 合约ETH余额
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev 获取管理员地址
     * @return 管理员地址
     */
    function getOwner() external view returns (address) {
        return _owner;
    }

    /**
     * @dev 获取存款前3名用户详情
     * @return 包含用户地址和存款金额的数组
     */
    function getTop3Depositors() external view returns (TopDepositor[3] memory) {
        return topDepositors;
    }
}