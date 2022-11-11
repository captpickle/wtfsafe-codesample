### wtf-safe合约foundry 复现



##### 01 重入攻击

文档链接：

https://wtf.academy/solidity-application/S01_ReentrancyAttack/

 执行命令：

```
forge test -vv --match-test  testsafe_01
```

预期结果：

```
[PASS] testsafe_01() (gas: 506662)
Logs:
  wtf safe 01 reentrancy attack
  bank balance before deposits: 0
  bank balance after deposits: 10
  attack balance before attack: 0
  attack balance after attack: 11

```
