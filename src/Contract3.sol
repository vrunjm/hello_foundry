// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Bank {
    address public admin;
    mapping(address => uint256) public balances;

    constructor() {
        admin = msg.sender;
    }

    function deposit() public payable virtual {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public virtual {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        // 新增：检查合约实际余额，避免转账失败
        require(address(this).balance >= amount, "Contract has no enough ETH");
        
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    function getBalance() public view virtual returns (uint256) {
        return balances[msg.sender];
    }

    function getAdmin() public view returns (address) {
        return admin;
    }

    function transferAdmin(address newAdmin) public {
        require(msg.sender == admin, "Only admin can change the admin address");
        require(newAdmin != address(0), "New admin can't be zero address");
        admin = newAdmin;
    }
}

contract BigBank is Bank {
    // 修正：modifier命名与功能匹配，限制存款>0.001 ETH
    modifier minDeposit() {
        require(msg.value > 0.001 ether, "Deposit must be greater than 0.001 ether");
        _;
    }

    // 修正：移除冗余的父合约构造调用
    constructor() {}

    // 修正：应用minDeposit modifier，增加存款上限检查
    function deposit() public payable override minDeposit {
        super.deposit();
        // 修正：闭合括号，逻辑改为“累计存款不超过100 ETH”
        require(balances[msg.sender] <= 100 ether, "Deposit exceeds the maximum limit");
    }

    // 修正：重写withdraw，仅Admin合约（管理员）可调用
    function withdraw(uint256 amount) public override {
        require(msg.sender == admin, "Only Admin contract can call withdraw");
        super.withdraw(amount);
    }

    // 修正：若需查询合约总余额，新增独立函数，不破坏原getBalance语义
    function getContractTotalBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 保留原getBalance语义：返回用户账面余额
    function getBalance() public view override returns (uint256) {
        return super.getBalance();
    }
}

contract Admin {
    // 修正：类型改为BigBank，匹配实际调用的合约
    BigBank public bigBank;
    // 新增：Admin合约的管理员（避免任意地址提款）
    address public admin;

    constructor(address _bankAddress) {
        bigBank = BigBank(_bankAddress);
        admin = msg.sender; // 部署者为Admin合约管理员
    }

    // 修正：增加权限控制，仅Admin合约管理员可调用
    function withdrawFromBigBank(uint256 _amount) public {
        require(msg.sender == admin, "Only Admin contract owner can call");
        bigBank.withdraw(_amount);
    }

    // 接收ETH，避免提款时ETH丢失
    receive() external payable {}

    // 辅助：转移Admin合约管理员权限
    function transferAdmin(address newAdmin) public {
        require(msg.sender == admin, "Only admin can transfer");
        admin = newAdmin;
    }
}