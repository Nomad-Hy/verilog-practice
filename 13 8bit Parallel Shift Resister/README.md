# 8-bit Shift Register with Parallel Load

## 📌 Description
Right Shift Register + Parallel Load 통합 구조.
- Reset: 비동기 active-low (rstb=0 시 즉시)
- Parallel Load: load=1일 때 din → pout (8비트 통째)
- Serial Shift: load=0일 때 sin이 MSB에, 우측으로 시프트

시리얼 통신 (UART 수신 등)의 핵심 회로.

## 🏗️ Architecture

```
                          sin
                           ↓
   ┌─────────────────────────────────────┐
   │ load=1: din → pout (병렬 로드)      │
   │ load=0: pout ← {sin, pout[7:1]}     │
   │         (우측 시프트, MSB에 sin)    │
   └─────────────────────────────────────┘
                           ↓
                       pout[7:0]
```

## 🔢 Truth Table

| rstb | load | 동작 |
|:----:|:----:|:----|
| 0 | x | pout ← 00000000 (reset) |
| 1 | 1 | pout ← din (병렬 로드, sin 무시) |
| 1 | 0 | pout ← {sin, pout[7:1]} (우측 시프트) |

### Right Shift 예시 (sin=1)

| Clock | pout (이전) | pout (다음) | 설명 |
|:-----:|:-----------:|:-----------:|:----|
| 0 | 00000000 | - | reset |
| 1 | 00000000 | 10000000 | sin=1 → MSB |
| 2 | 10000000 | 11000000 | 시프트 + sin=1 |
| 3 | 11000000 | 11100000 | 시프트 + sin=1 |
| 4 | 11100000 | 11110000 | 시프트 + sin=1 |

## 💡 sin의 역할

sin = 외부 시리얼 데이터 입구

- load=1: pin이 통째로 → sin 무시
- load=0: 매 클럭마다 sin이 MSB로 → 시리얼 데이터 수신

시프트 레지스터의 본질: 외부에서 1비트씩 들어오는 데이터를 모아 병렬 형태로 변환.

## 💻 Implementation

```verilog
module shift_resister(
    input            clk,
    input            rstb,
    input            load,
    input            sin,
    input      [7:0] din,
    output reg [7:0] pout
);
    always @(posedge clk or negedge rstb) begin
        if (!rstb)      pout <= 8'b00000000;
        else if (load)  pout <= din;
        else            pout <= {sin, pout[7:1]};
    end
endmodule
```

### 핵심 트릭

Concatenation `{sin, pout[7:1]}`
- sin = 새 MSB (1비트)
- pout[7:1] = 기존 비트들 중 LSB 제외 (7비트)
- 합치면 8비트 = 우측 시프트 결과


## 🎓 게이트 vs RTL — 핵심 깨달음

### 게이트 관점 
8개의 MUX + 8개의 D-FF로 구성. 각 비트마다 load 신호로 선택.

### RTL 관점 
```verilog
if (load) pout <= din;
else      pout <= {sin, pout[7:1]};
```

RTL은 의도만 표현, 합성 도구가 MUX 게이트 자동 생성.

## 📂 Files
- `shift_resister.sv` — 시프트 레지스터 모듈
- `tb_shift_resister.sv` — 시리얼 'A' 수신 시나리오 testbench

## ✅ Simulation Result

### 단계별 시뮬레이션

| Time | rstb | load | sin | din | pout | 단계 |
|:----:|:----:|:----:|:---:|:--------:|:--------:|:----|
| 0 | 0 | 0 | 0 | 00000000 | 00000000 | Reset |
| 25 | 1 | 1 | 0 | 10101010 | **10101010** | Parallel Load |
| 35 | 1 | 0 | 0 | 10101010 | 01010101 | Right Shift |
| 45 | 1 | 0 | 0 | 10101010 | 00101010 | Right Shift |
| 55 | 0 | 0 | 0 | - | 00000000 | Async Reset |
| 75 | 1 | 0 | 1 | - | 10000000 | 'A' bit 1 (MSB) |
| 85 | 1 | 0 | 0 | - | 01000000 | 'A' bit 2 |
| 95 | 1 | 0 | 0 | - | 00100000 | 'A' bit 3 |
| 105 | 1 | 0 | 0 | - | 00010000 | 'A' bit 4 |
| 115 | 1 | 0 | 0 | - | 00001000 | 'A' bit 5 |
| 125 | 1 | 0 | 0 | - | 00000100 | 'A' bit 6 |
| 135 | 1 | 0 | 1 | - | 10000010 | 'A' bit 7 |
| 145 | 1 | 0 | 0 | - | 01000001 | 'A' |

### 핵심 검증 포인트


Parallel Load 
- load=1 + din=10101010 → pout=10101010
- 한 번에 전체 로드

Serial Shift 
- load=0 + sin → 매 클럭 우측 시프트
- MSB에 sin 입력

시리얼 'A' 수신 
- 시리얼 입력: 1,0,0,0,0,0,1,0
- 8 클럭 후 pout = 01000001 = 'A' 



### Issue : `q << 1` 시도 (시프트 연산자)

원인: Verilog `<<` 시프트 연산자는 빈자리에 0을 자동 채움. sin 무시됨.

수정
```verilog
// Before
pout <= pout << 1;        // sin 무시, LSB에 0

// After
pout <= {sin, pout[7:1]}; // sin이 MSB에 ⭐
```

Lesson: 시프트 레지스터는 concatenation 사용. 시프트 연산자(`<<`)와 다름.

## 📚 Learned

### 시프트 레지스터 본질
- 시리얼 → 병렬 변환 (UART, SPI 등)
- sin = 외부 시리얼 데이터 라인
- 매 클럭마다 외부가 sin 값 결정

### Verilog 기법
- Mode 분기 (load=1: 병렬, load=0: 시프트)

### 게이트 vs RTL
- 게이트 구조 = 합성된 결과 (MUX 8개)
- RTL 코드 = 의도 표현 (if-else)
- 합성 도구가 자동 변환

### 디버깅 
- `<<` 연산자 ≠ 시프트 레지스터


## 💡응용(Bonus) — UART 수신 흐름

```
원격 PC ─ 시리얼 통신 ─→ Start bit 검출
                       ↓
                  Shift Register 활성 (load=0)
                       ↓
                  매 클럭 sin으로 8비트 수신
                       ↓
                  pout = 8비트 글자
                       ↓
              상위 시스템에 병렬 전달
```
