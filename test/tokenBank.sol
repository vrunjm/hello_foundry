
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

interface IERC20 {
    // 转账函数：从调用者地址转 value 个代币到 to 地址
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    // 转账函数：从合约地址转 value 个代币到 to 地址
    function transfer(address to, uint256 value) external returns (bool);
    // 查询余额函数
    function balanceOf(address account) external view returns (uint256);
}

contract testToken{
    IERC20 public immutable token;
    mapping(address => uint256) public userDeposits;
    // 存
    event Deposited(address indexed user,uint256 amount);
    // 取
    event Withdrawn(address indexed user, uint256 amount);


    constructor(address _tokenAddress){
        require(_tokenAddress != address(0),"Token addrss cannot be zero");
        token = IERC20(_tokenAddress);

    }

    /**
     * 存入代币
     */
    function deposit(uint256 amount) external{
        token.transferFrom(msg.sender, address(this), amount);
        userDeposits[msg.sender] += amount;
        emit Deposited(msg.sender,amount);
    }

    /**
     * @dev 取出代币
     * @param amount 取出的代币数量
     */
    function withdraw(uint256 amount) external {
        // 安全检查：取出数量不能为 0
        require(amount > 0, "Amount must be greater than 0");
        // 安全检查：用户存入余额足够
        require(userDeposits[msg.sender] >= amount, "Insufficient deposit balance");

        // 1. 扣减用户存入余额（先扣减再转账，防止重入攻击）
        userDeposits[msg.sender] -= amount;

        // 2. 从合约地址转账代币到用户地址
        bool success = token.transfer(msg.sender, amount);
        require(success, "Token withdrawal failed");

        // 3. 触发取出事件
        emit Withdrawn(msg.sender, amount);
    }

    /**
     * @dev 查询用户存入的代币余额（方便用户查看）
     * @param user 用户地址
     * @return 用户存入的代币数量
     */
    function getDepositBalance(address user) external view returns (uint256) {
        return userDeposits[user];
    }

    /**
     * @dev 查询合约当前持有的代币总余额（用于验证合约资金）
     * @return 合约的代币余额
     */
    function getContractTokenBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }


}