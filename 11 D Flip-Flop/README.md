# D Flip-Flop (Active-Low Async Reset)

## 📌 Description
순차회로: 클럭 엣지에서 입력 d를 저장하는 메모리 회로.
- 비동기 active-low reset (`resetn`)사용
- posedge clk에서 d → q 전달

## 🏗️ Architecture

```
         ┌──────────┐
   d ───→│          │───→ q
         │   D-FF   │
  clk ──→│          │
         │ (posedge)│
 resetn─→│  async   │
         │ (active- │
         │  low)    │
         └──────────┘
```

동작:
- `rst_n = 0` → q = 0 (즉시, 비동기)
- `posedge clk` resetn =1일 때) → q = d
- 그 외 → q 유지

## 💻 Implementation

```verilog
module dflipflop(
    input  d,
    input  clk,
    input resetn,                    // active-low reset
    output reg q
);
    always @(posedge clk or negedge resetn) begin
        if (!resetn) q <= 1'b0;       // resetn=0이면 q=0
        else        q <= d;          // 클럭 엣지에 샘플
    end
endmodule
```
## 📂 Files
- `design.sv` — D FlipFlop 모듈
- `testbench.sv` — 검증

- 
## 🔢 Timing Diagram

```
clk    ___|‾‾‾|___|‾‾‾|___|‾‾‾|___|‾‾‾|___
resetn  __________________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
d      0       1       1       0       1
q      0   0   0   0   1   1   0   0   1
                       ↑       ↑       ↑
                  Reset 해제   엣지     엣지
                     첫 엣지   (d=0)   (d=1)
```

## 📚 Learned

- `negedge resetn` — 1→0 변화 트리거
- 비동기 reset 동작 — 클럭 무관 즉시 적용
- 순차회로 non-blocking — `<=` 사용

