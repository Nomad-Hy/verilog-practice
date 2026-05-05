#XOR Gate

## 📌 Description
2 input 1output XOR 게이트
입력중 1의 개수가 홀수이면 1 짝수면 0이 출력으로 나온다.

## 💻 Implementation
`assign y= (a!=b);`으로 하더라도 성립하지만
`assign y= a^b;` ^연산자를 사용해 더 간단하게 만들 수도 있다.

## 📂 Files
- `design.sv` — AND 게이트 모듈
- `testbench.sv` — 4가지 케이스 테스트벤치

## ✅ Simulation Result

| # | a | b | Expected | Actual | Result |
|:-:|:-:|:-:|:--------:|:------:|:------:|
| 1 | 0 | 0 |    0     |   0    |   ✅   |
| 2 | 0 | 1 |    1     |   1    |   ✅   |
| 3 | 1 | 0 |    1     |   1    |   ✅   |
| 4 | 1 | 1 |    0     |   0    |   ✅   |
