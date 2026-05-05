#OR Gate

## 📌 Description

2 input 1 output OR게이트
두 입력중 하나라도 1이면 출력은 1이 된다.

## 🔢 Truth Table
| a | b | out |
|---|---|-----|
| 0 | 0 |  0  |
| 0 | 1 |  1  |
| 1 | 0 |  1  |
| 1 | 1 |  1  |

## 💻 Implementation
`assign y=a|b;`

## 📂 Files
- `design.sv` — AND 게이트 모듈
- `testbench.sv` — 4가지 케이스 테스트벤치

## ✅ Simulation Result

| # | a | b | Expected | Actual | Result |
|:-:|:-:|:-:|:--------:|:------:|:------:|
| 1 | 0 | 0 |    0     |   0    |   ✅   |
| 2 | 0 | 1 |    1     |   1    |   ✅   |
| 3 | 1 | 0 |    1     |   1    |   ✅   |
| 4 | 1 | 1 |    1     |   1    |   ✅   |
