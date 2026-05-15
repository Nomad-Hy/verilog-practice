# Parameterized Decoder (with assign + shift)

## 📌 Description
N×2^N 디코더. parameter로 다양한 비트 폭 고려.
- N=2 → 2:4 디코더
- N=3 → 3:8 디코더
- N=4 → 4:16 디코더

같은 코드로 다양한 비트 폭 디코더 생성 가능.

## 🔢 Truth Table (N=2 기준)

| in[1:0] | out[3:0] |
|:-------:|:--------:|
|   00    |   0001   |
|   01    |   0010   |
|   10    |   0100   |
|   11    |   1000   |

> N=3이면 입력 3비트, 출력 8비트

## 💻 Implementation

### Parameter
```verilog
#(parameter N=2)
```
- 인스턴스화 시 변경 가능: `#(.N(3))`
- 기본값 N=2

### Core Logic
```verilog
assign out = 1 << in;
```


동작 원리:
- `1` (모든 비트 0 중 LSB만 1)을 `in` 값만큼 왼쪽 시프트
- in=0 → `0001`
- in=1 → `0010`
- in=2 → `0100`
- in=3 → `1000`

###case버전

```
case (in)
      2'b00:out=4'b0001;
      2'b01:out=4'b0010;
      2'b10:out=4'b0100;
      2'b11:out=4'b1000;
    endcase
```
case는 더욱 직관적으로 볼 수 있음.
하지만 비트수가 늘어나면 복잡해짐.


### Bit Width
```verilog
input  [N-1:0]    in       // N비트 입력
output [2**N-1:0] out      // 2^N비트 출력
```

- N=2 → 입력 2비트, 출력 4비트
- N=3 → 입력 3비트, 출력 8비트

## 📂 Files
- `design.sv` — Parameterized decoder 모듈
- `testbench.sv` — for 루프로 모든 케이스 자동 검증

## ✅ Simulation Result (N=2)

| # | in | Expected out | Actual out | Result |
|:-:|:--:|:------------:|:----------:|:------:|
| 1 | 00 |     0001     |    0001    |   ✅   |
| 2 | 01 |     0010     |    0010    |   ✅   |
| 3 | 10 |     0100     |    0100    |   ✅   |
| 4 | 11 |     1000     |    1000    |   ✅   |

**4/4 cases passed ✅**

### Raw Output
```
Time=0  in=00 out=0001
Time=10 in=01 out=0010
Time=20 in=10 out=0100
Time=30 in=11 out=1000
```

## 🐛 Bug & Fix Log

### Issue: 출력 비트 폭 표기 실수


원인: 
- 작성: `output [N**2-1:0] out`
- `N**2 = N × N` (N제곱이 아님)
- N=3 → 9 (틀림, 8이어야 함)

수정:
```verilog
// Before
output [N**2-1:0] out

// After  
output [2**N-1:0] out
```


## 📚 Learned
- Parameter 사용한 모듈 일반화
- Shift 연산자 `<<` 활용한 디코더 구현
- for 루프 testbench — 모든 케이스 자동 검증
- 같은 회로 다양한 방식 구현 (case vs shift vs generate)


