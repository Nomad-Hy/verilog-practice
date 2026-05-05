#1bitFullAdder (1비트 전가산기)

## 📌 Description

1비트 두입력의 값을 계산하는 전가산기, 가산기와는 다르게 cin 이라는 캐리입력이 추가된다.
-`sum` : 합
-`carry`: 자리올림

## 🔢 Truth Table
| a | b | cin | sum | cout |
|:-:|:-:|:---:|:---:|:----:|
| 0 | 0 |  0  |  0  |   0  |  
| 0 | 0 |  1  |  1  |   0  |
| 0 | 1 |  0  |  1  |   0  | 
| 0 | 1 |  1  |  0  |   1  | 
| 1 | 0 |  0  |  1  |   0  | 
| 1 | 0 |  1  |  0  |   1  | 
| 1 | 1 |  0  |  0  |   1  | 
| 1 | 1 |  1  |  1  |   1  | 

## 🧠 Logic Pattern

-sum: 3개의 입력 a,b,cin 중 하나라도 1이면 1 --> (a^b^cin) 
-cout:3개의 입력에서 2개의 조합했을 경우 나오는 3가지 경우에서 or 결과가 하나라도 1이면 1이다. --> (a&b)||(a&cin)||(b&cin)

## 💻 Implementation

`assign sum=a^b^cin;`
`assign cout=(a&b)||(a&cin)||(b&cin);`

## 📂 Files
- `design.sv` — 1bit Full Adder 모듈
- `testbench.sv` — 케이스 검증

✅ Simulation Result

### Lesson Learned

반가산기와 마찬가지로 진리표에서 특정 패턴을 찾아내는것이 관건이다.
구현자체는 어렵지 않았다.
