# N-bit Full Adder (Parameterized Ripple Carry Adder)

## 📌 Description
Parameter로 비트 폭 가변 N비트 전가산기.
- N=4 → 4비트 가산기
- N=8 → 8비트 가산기
- N=32 → 32비트 가산기

1비트 전가산기를 `generate`로 N번 인스턴스화해 자동 구성.

## 🏗️ Architecture

```
   a[0] b[0] cin                  a[1] b[1]                    a[N-1] b[N-1]
     ↓   ↓    ↓                     ↓   ↓                          ↓    ↓
   ┌──────────┐  carry[1]        ┌──────────┐  carry[2]        ┌──────────┐
   │  FA[0]   │ ───────────────→ │  FA[1]   │ ──── ... ────→   │ FA[N-1]  │
   │ (1-bit)  │                  │ (1-bit)  │                  │ (1-bit)  │
   └──────────┘                  └──────────┘                  └──────────┘
         ↓                              ↓                              ↓
       sum[0]                        sum[1]                        sum[N-1]
                                                                       ↓
                                                                     cout
```

Carry chain: 이전 FA의 `cout` → 다음 FA의 `cin`

## 🔢 동작 예시 (N=8)

| a (dec) | b (dec) | cin | sum (dec) | cout | 설명 |
|:-------:|:-------:|:---:|:---------:|:----:|:----|
|   0     |   0     |  0  |     0     |  0   | 0 + 0 = 0 |
|  100    |   50    |  0  |    150    |  0   | 정상 덧셈 |
|  128    |  127    |  0  |    255    |  0   | 8비트 최대 |
|  128    |  128    |  0  |     0     |  1   | **Overflow!** |
|  255    |    1    |  0  |     0     |  1   | **Overflow!** |
|  255    |  255    |  1  |    255    |  1   | 최대 + 최대 + 1 |

> Overflow = 결과가 8비트 범위(0~255) 초과 → cout=1로 알림

## 💻 Implementation

### 1-bit Full Adder
```verilog
module fulladder_1bit(
    input  a, b, cin,
    output cout, sum
);
    assign {cout, sum} = a + b + cin;
endmodule
```

핵심: `{cout, sum}` (concatenation)
- `a + b + cin`은 최대 3 (2비트)
- `{cout, sum}` = 2비트 신호로 묶음
- 자동으로 cout = MSB, sum = LSB

→ XOR/AND 게이트 표현 없이 산술 연산 한 줄로 표현현.

### N-bit Full Adder (Generate)
```verilog
module fulladder_nbit #(parameter N=4) (
    input  [N-1:0] a, b,
    input          cin,
    output         cout,
    output [N-1:0] sum
);
    wire [N:0] carry;
    
    assign carry[0] = cin;
    assign cout = carry[N];
    
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : fa_loop
            fulladder_1bit fa_inst (
                .a(a[i]), .b(b[i]), .cin(carry[i]),
                .cout(carry[i+1]), .sum(sum[i])
            );
        end
    endgenerate
endmodule
```

핵심  3가지:
1. `wire [N:0] carry` — N+1 비트 carry chain
   - `carry[0]` = 입력 cin
   - `carry[N]` = 출력 cout
   - 중간은 generate가 자동 연결
   - 
2. `generate ... endgenerate` — 컴파일 시 회로 자동 복사
3. 
4. `begin : fa_loop` — 블록 이름 (필수)


## 📂 Files
- `design.sv` — fulladder_1bit + fulladder_nbit 모듈
- `testbench.sv` — N=8로 인스턴스화한 8비트 가산기 검증

## ✅ Simulation Result (N=8)

| # | a | b | cin | sum | cout | 검증 |
|:-:|:---:|:---:|:---:|:---:|:----:|:----:|
| 1 |   0 |   0 |  0  |   0 |  0   | 0+0=0 ✅ |
| 2 | 100 |  50 |  0  | 150 |  0   | 100+50=150 ✅ |
| 3 | 128 | 127 |  0  | 255 |  0   | 8비트 최대 ✅ |
| 4 | 128 | 128 |  0  |   0 |  1   | Overflow ✅ |
| 5 | 255 |   1 |  0  |   0 |  1   | Overflow ✅ |
| 6 | 255 | 255 |  1  | 255 |  1   | 255+255+1=511 ✅ |


### Raw Output
```
Time:0   | A=  0 B=  0 Cin=0 | Cout=0 Sum=  0
Time:10  | A=100 B= 50 Cin=0 | Cout=0 Sum=150
Time:20  | A=128 B=127 Cin=0 | Cout=0 Sum=255
Time:30  | A=128 B=128 Cin=0 | Cout=1 Sum=  0
Time:40  | A=255 B=  1 Cin=0 | Cout=1 Sum=  0
Time:50  | A=255 B=255 Cin=1 | Cout=1 Sum=255
```

## 🐛 Bug & Fix Log

### Issue: Generate block instance 이름 충돌
`for` 루프 안 인스턴스 이름이 모두 같음 (`instances`)

원인: generate 블록에 이름이 없으면 일부 시뮬레이터·합성 도구 경고

수정:
```verilog
// Before
for (i = 0; i < N; i = i + 1)
    fulladder_1bit instances(...);

// After  
for (i = 0; i < N; i = i + 1) begin : fa_loop
    fulladder_1bit fa_inst(...);
end
```

Lesson: generate for 루프엔 항상 `begin : 블록이름` 추가.

## 📚 Learned
- Concatenation `{cout, sum}` — 신호 묶기로 한 줄 가산기
- Parameter `#(parameter N=4)` — 비트 폭 가변
- Generate + genvar*— 회로 자동 복사 (재사용성)
- Carry chain (`wire [N:0] carry`) — 1비트 더 큰 와이어로 cin/cout 통합
- Module 계층 구조 — 작은 모듈 (1-bit) → 큰 모듈 (N-bit)
- Overflow 처리 — cout으로 알림

