# 4-bit Comparator (4비트 비교기)

## 📌 Description
2개의 4비트 입력 a, b를 비교해 3가지 결과를 출력하는 회로.
- gt: a > b일 때 1
- lt: a < b일 때 1
- eq: a == b일 때 1

세 출력 중 항상 정확히 하나만 1. 한 번에 두 개 1이 될 수 없음.

## 🔢 동작 요약

| 조건 | gt | lt | eq |
|:----:|:--:|:--:|:--:|
| a > b | 1 | 0 | 0 |
| a < b | 0 | 1 | 0 |
| a == b | 0 | 0 | 1 |

### 진리표 (일부)
| a (decimal) | b (decimal) | gt | lt | eq |
|:-----------:|:-----------:|:--:|:--:|:--:|
| 0 | 0 | 0 | 0 | 1 |
| 5 | 5 | 0 | 0 | 1 |
| 15 | 11 | 1 | 0 | 0 |
| 8 | 1 | 1 | 0 | 0 |
| 3 | 12 | 0 | 1 | 0 |
| 0 | 15 | 0 | 1 | 0 |



## 💻 Implementation

### Core Logic (3줄)
```verilog
assign gt = a > b;
assign lt = a < b;
assign eq = a == b;
```

Verilog 비교 연산자 직접 사용.
- `>`, `<`, `==` 모두 1비트 결과 (조건 만족 시 1)
- assign으로 wire 출력에 연결


## 📂 Files
- `design.sv` — 4-bit Comparator 모듈
- `testbench.sv` — 7가지 케이스 자동 검증

## ✅ Simulation Result

| # | a | b | gt | lt | eq | Result |
|:-:|:-:|:-:|:--:|:--:|:--:|:------:|
| 1 |  0 |  0 |  0 |  0 |  1 |   ✅   |
| 2 |  5 |  5 |  0 |  0 |  1 |   ✅   |
| 3 | 15 | 15 |  0 |  0 |  1 |   ✅   |
| 4 | 15 | 11 |  1 |  0 |  0 |   ✅   |
| 5 |  8 |  1 |  1 |  0 |  0 |   ✅   |
| 6 |  3 | 12 |  0 |  1 |  0 |   ✅   |
| 7 |  0 | 15 |  0 |  1 |  0 |   ✅   |



### Raw Output
```
PASS: a= 0 b= 0 | gt=0 lt=0 eq=1
PASS: a= 5 b= 5 | gt=0 lt=0 eq=1
PASS: a=15 b=15 | gt=0 lt=0 eq=1
PASS: a=15 b=11 | gt=1 lt=0 eq=0
PASS: a= 8 b= 1 | gt=1 lt=0 eq=0
PASS: a= 3 b=12 | gt=0 lt=1 eq=0
PASS: a= 0 b=15 | gt=0 lt=1 eq=0
=== All tests done! ===
```

## 🐛 Bug & Fix Log


### Issue 1: 검증 표현 헷갈림
GT는 `!((a>b)==gt)`, LT는 `(!(a<b)==lt)`로 NOT 위치 불일치

가독성 떨어지는 조건 표현

수정: `!==` 연산자로 통일
```verilog
// Before
if (!((a>b)==gt)) $error(...);

// After  
if (gt !== (a > b)) $error(...);
```

### Issue 2: $finish 누락
always 블록만으로는 시뮬 종료 안 됨 (무한 루프 위험)

`$finish;` 추가

## 📚 Learned
- Verilog 비교 연산자 (`>`, `<`, `==`): 1비트 결과
- 다양한 시나리오 테스트의 중요성 (한 케이스로는 부족)
- 자동 검증 시 `!==` 사용 (x/z까지 비교)
- always 블록은 시뮬 종료 안 됨 → `$finish` 필요
- `$error`로 실패 케이스만 콕 집어 알림


