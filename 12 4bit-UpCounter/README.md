# 4-bit Up Counter — Async vs Sync 비교

## 📌 Description
4비트 업 카운터의 두 가지 구현 방식을 직접 만들어 비교.

- Asynchronous (Ripple) Counter: T-FF 체인 
- Synchronous Counter with Enable: D-FF 기반 

핵심 비교 포인트: 카운팅 동작 방식 (Counter 분류 기준)

## 🏗️ Architecture 비교

### Asynchronous (Ripple) Counter

```
   clk ─→ [T-FF] → cnt[0] ─→ [T-FF] → cnt[1] ─→ [T-FF] → cnt[2] ─→ [T-FF] → cnt[3]
            ↑                ↑                ↑                ↑
         negedge          negedge          negedge          negedge
           clk            cnt[0]           cnt[1]           cnt[2]
```

각 FF가 다른 클럭 (Ripple). 이전 비트가 다음 비트의 클럭 역할.

### Synchronous Counter

```
   clk ──┬─[FF]─→ cnt[0]
         ├─[FF]─→ cnt[1]
         ├─[FF]─→ cnt[2]
         └─[FF]─→ cnt[3]
```

모든 FF가 동일 clk (동시 업데이트).


## 💻 Implementation

### Async Counter — T-FF 체인

```verilog
module upcounter_async(
    input            clk,
    input            rstb,
    output reg [3:0] cnt
);
    // cnt[0]: clk의 negedge에 토글
    always @(negedge clk or negedge rstb) begin
        if (!rstb) cnt[0] <= 1'b0;
        else       cnt[0] <= ~cnt[0];
    end
    
    // cnt[1]: cnt[0]의 negedge에 토글
    always @(negedge cnt[0] or negedge rstb) begin
        if (!rstb) cnt[1] <= 1'b0;
        else       cnt[1] <= ~cnt[1];
    end
    
    // cnt[2]: cnt[1]의 negedge에 토글
    always @(negedge cnt[1] or negedge rstb) begin
        if (!rstb) cnt[2] <= 1'b0;
        else       cnt[2] <= ~cnt[2];
    end
    
    // cnt[3]: cnt[2]의 negedge에 토글
    always @(negedge cnt[2] or negedge rstb) begin
        if (!rstb) cnt[3] <= 1'b0;
        else       cnt[3] <= ~cnt[3];
    end
endmodule
```

핵심 트릭:
- T-FF 동작: `q <= ~q` (매 엣지마다 토글)
- Ripple: 이전 비트가 다음 비트 클럭으로

### Sync Counter — Enable + Wrap-around

```verilog
module upcounter_sync(
    input            clk,
    input            en,
    input            rstb,
    output reg [3:0] cnt
);
    always @(posedge clk or negedge rstb) begin
        if (!rstb) 
            cnt <= 4'b0000;
        else if (en) begin
            if (cnt != 4'b1111) cnt <= cnt + 1;
            else                cnt <= 4'b0000;    // wrap-around
        end
    end
endmodule
```

특징:
- 단일 always 블록 (모든 비트 동시)
- Enable 신호 (`en=1`일 때만 카운트)
- Wrap-around (15 → 0 순환)
- 비동기 reset (rstb=0이면 즉시 cnt=0)

## 🔢 주파수 분주 효과 (Async)

```
clk:    1010101010101010...  (주파수 f)
cnt[0]: 1100110011001100...  (f/2)
cnt[1]: 1111000011110000...  (f/4)
cnt[2]: 1111111100000000...  (f/8)
cnt[3]: ...                  (f/16)
```

각 비트가 이전 비트의 절반 주파수. 결과적으로 4비트 카운트.

## 📊 Async vs Sync 비교

| 항목 | Async (Ripple) | Sync |
|:---:|:---:|:---:|
| 클럭 신호 | 각 비트마다 다름 | 모든 비트 동일 ⭐ |
| 게이트 수 | 적음 | 많음 |
| 동작 속도 | 느림 (지연 누적) | 빠름 ⭐ |
| Glitch | ⚠️ 있음 | ✅ 없음 |
| 타이밍 분석 (STA) | 어려움 | ✅ 쉬움 |
| 고속 시스템 | ❌ 부적합 | ✅ 적합 |
| 실무 사용 | 거의 X | ⭐ 표준 |
| 구현 복잡도 | 단순 (T-FF) | 단순 (D-FF + 가산기) |


### Async의 Glitch 예시 — 15 → 0 전환

각 비트 지연이 누적되어 일시적 잘못된 값:

```
1111 → 1110 → 1100 → 1000 → 0000
(15)    (14)    (12)    (8)    (0)
                                ↑
                             목표값
```

4비트라 4번 글리치. 16비트면 16번. 실무 부적합.

### Sync는 한 번에

```
1111 → 0000
(15)    (0)
```

모든 비트 동시 업데이트. Glitch 없음.

## 🔢 Sync Counter 시나리오

| 단계 | rstb | en | 동작 |
|:---:|:----:|:--:|:----|
| 1 | 0 | x | cnt = 0 (reset) |
| 2 | 1 | 0 | cnt = 0 (유지, en=0) |
| 3 | 1 | 1 | cnt 증가 (0→1→...→15) |
| 4 | 1 | 1 | cnt = 0 (15 다음 wrap) |
| 5 | 1 | 0 | cnt 멈춤 (중간 정지) |
| 6 | 1 | 1 | cnt 재개 |
| 7 | 0 | x | cnt = 0 (비동기 reset) |

## 📂 Files

- `upcounter_async.sv` — 비동기 카운터 (T-FF 체인)
- `upcounter_sync.sv` — 동기 카운터 (Enable + Wrap-around)
- `tb_async.sv` — 비동기 테스트벤치
- `tb_sync.sv` — 동기 테스트벤치 (en 신호 단계별)

## ✅ Simulation Result

### Async Counter

```
Time=15  rstb=0 cnt=0000
Time=30  rstb=1 cnt=0001
Time=50  rstb=1 cnt=0010
...
Time=170 rstb=1 cnt=1111
Time=190 rstb=1 cnt=0000  (wrap-around, Ripple)
```

### Sync Counter

```
Time=20  rstb=1 en=0 cnt=0000  (en=0, 카운트 X)
Time=40  rstb=1 en=1 cnt=0001  (en=1, 카운트 시작)
Time=140 rstb=1 en=0 cnt=10    (en=0, 중간 정지)
Time=170 rstb=1 en=1 cnt=11    (en=1, 재개)
Time=230 rstb=1 en=1 cnt=15    
Time=240 rstb=1 en=1 cnt=0     (wrap-around, 동시 업데이트)
```


## 📚 Learned

### Async Counter
- T-Flip Flop(`q <= ~q`) 직접 구현
- Ripple effect — 이전 비트가 다음 클럭
- 주파수 분주 — 각 비트가 절반 주파수
- Glitch, Skew 실제 체감

### Sync Counter
- Enable 신호 — 조건부 카운트
- Wrap-around — 15 → 0 순환
- 단일 always 블록 — 모든 비트 동시
- 비동기 reset with 동기 카운팅 — 실무 표준


