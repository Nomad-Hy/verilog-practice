# AND Gate

## 📌 Description
2-input 1-output AND 게이트.
두 입력이 모두 1일 때만 출력이 1이고 나머지는 0으로 출력된다.

## 🔢 Truth Table
| a | b | out |
|---|---|-----|
| 0 | 0 |  0  |
| 0 | 1 |  0  |
| 1 | 0 |  0  |
| 1 | 1 |  1  |

## 💻 Implementation
`assign out = a & b;`

& 연산자를 사용해 간단하게 구현

## 📂 Files
- `design.sv` — AND 게이트 모듈
- `testbench.sv` — 4가지 케이스 테스트벤치


## ✅ Simulation Result

| # | a | b | Expected | Actual | Result |
|:-:|:-:|:-:|:--------:|:------:|:------:|
| 1 | 0 | 0 |    0     |   0    |   ✅   |
| 2 | 0 | 1 |    0     |   0    |   ✅   |
| 3 | 1 | 0 |    0     |   0    |   ✅   |
| 4 | 1 | 1 |    1     |   1    |   ✅   |

**4/4 cases passed ✅**

### Raw Output
```
Time=0  a=0 b=0 out=0
Time=10 a=0 b=1 out=0
Time=20 a=1 b=0 out=0
Time=30 a=1 b=1 out=1
```
