# XNOR Gate

## 📌 Description
2-input 1-output XNOR 게이트.
XOR 과 반대로 입력이 홀수이면 출력은 0 짝수면 1이 된다.

## 🔢 Truth Table
| a | b | out |
|---|---|-----|
| 0 | 0 |  1  |
| 0 | 1 |  0  |
| 1 | 0 |  0  |
| 1 | 1 |  1  |

## 💻 Implementation
`assign y=~(a!=b);`
또는
`assign y=~(a^b);`

## 📂 Files
- `design.sv` — XNOR 게이트 모듈
- `testbench.sv` — 4가지 케이스 테스트벤치

## ✅ Simulation Result
| # | a | b | Expected | Actual | Result |
|:-:|:-:|:-:|:--------:|:------:|:------:|
| 1 | 0 | 0 |    1     |   1    |   ✅   |
| 2 | 0 | 1 |    0     |   0    |   ✅   |
| 3 | 1 | 0 |    0     |   0    |   ✅   |
| 4 | 1 | 1 |    1     |   1    |   ✅   |
