# Half Adder (반가산기)

## 📌 Description
1비트 두 입력의 합을 계산하는 가장 기본 가산기.
- `sum`: 합 (XOR 결과)
- `carry`: 자리올림 (AND 결과)

전가산기와 달리 이전 자리의 캐리를 받지 않음. 4비트, 8비트 가산기의 시작점.

## 🔢 Truth Table

| a | b | sum | carry |
|:-:|:-:|:---:|:-----:|
| 0 | 0 |  0  |   0   |
| 0 | 1 |  1  |   0   |
| 1 | 0 |  1  |   0   |
| 1 | 1 |  0  |   1   |

## 🧠 Logic Pattern

진리표에서 패턴 찾기:
- sum: a, b가 다를 때만 1 → XOR (`^`)
- carry: a, b 둘 다 1일 때만 1 → AND (`&`)

## 💻 Implementation

`always @(*)` 블록으로 구현. 출력이 always 안에서 할당되므로 `output reg` 선언 필요.

```verilog
module half_adder(
    input  a,
    input  b,
    output reg sum,
    output reg carry
);
    always @(*) begin
        sum   = a ^ b;
        carry = a & b;
    end
endmodule
```

> `assign`으로도 동일 회로 구현 가능 (`assign sum = a ^ b;`)

## 📂 Files
- `design.sv` — Half adder 모듈
- `testbench.sv` —  케이스 검증

## ✅ Simulation Result

| # | a | b | Expected (sum, carry) | Actual (sum, carry) | Result |
|:-:|:-:|:-:|:---------------------:|:-------------------:|:------:|
| 1 | 0 | 0 |        (0, 0)         |       (0, 0)        |   ✅   |
| 2 | 0 | 1 |        (1, 0)         |       (1, 0)        |   ✅   |
| 3 | 1 | 0 |        (1, 0)         |       (1, 0)        |   ✅   |
| 4 | 1 | 1 |        (0, 1)         |       (0, 1)        |   ✅   |


> 1+1=2 (이진수 10) → sum=0, carry=1. 자리올림 발생.



### Lesson Learned
- testbench의 wire 이름과 design의 출력 포트 이름 일치 필요
- 의미 명확한 이름(`sum`, `carry`) 사용이 디버깅·가독성에 유리
- 진리표에서 특정 패턴을 찾는건 굉장히 중요하다. 


## 🎯 Key Takeaway
> **반가산기는 가산기 회로의 첫 발걸음.**  
> XOR + AND 조합 한 줄짜리지만, 이걸 이해하면 1비트 전가산기 → 4비트 가산기 → ALU까지 확장 가능.
