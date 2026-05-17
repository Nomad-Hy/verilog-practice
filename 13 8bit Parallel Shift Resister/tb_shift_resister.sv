`timescale 1ns/1ps
module tb_shift_resister;
  
  reg clk,rstb,load,sin;
  reg [7:0]din;
  
  wire [7:0]pout;
  
  shift_resister instance1(.clk(clk),.rstb(rstb),.load(load),.sin(sin),.din(din),.pout(pout));
  
  initial clk=1'b0;
  
  always #5 clk=~clk;
  
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_shift_resister);
    // 1단계: 초기화 + Reset
    rstb = 0; load = 0; sin = 0; din = 8'b00000000;
    #15;

    // 2단계: Reset 해제, 아직 동작 X
    rstb = 1;
    #10;

    // 3단계: Parallel Load 테스트 (load=1)
    load = 1; din = 8'b10101010;
    #10;                              // 한 클럭 후 pout = 10101010

    // 4단계: Load 해제, Shift 시작 (load=0)
    load = 0;
    #20;                              // sin=0인 상태로 시프트 2번

    // 5단계: Reset 다시 (시리얼 'A' 받기 준비)
    rstb = 0;
    #10;
    rstb = 1;

    // 6단계: 시리얼 'A' 수신 (01000001)
    // Right shift라 MSB에 sin 들어감
    // 'A'의 MSB부터 시리얼로 전송 (0,1,0,0,0,0,0,1)
    sin = 0; #10;   // 1st bit
    sin = 1; #10;   // 2nd bit
    sin = 0; #10;   // 3rd bit
    sin = 0; #10;   // 4th bit
    sin = 0; #10;   // 5th bit
    sin = 0; #10;   // 6th bit
    sin = 0; #10;   // 7th bit
    sin = 1; #10;   // 8th bit

    // 이 시점에서 pout = 01000001 = 'A' (ASCII)

    // 7단계: 추가 시프트 확인
    sin = 0;
    #30;

    $display("=== Simulation End ===");
    $finish;
    
    
  end
  
  
  
  
  
  
  initial begin
    
    $monitor("Time=%0t, clk=%b,rstb=%b,load=%b,sin=%b,din=%b,pout=%b",$time,clk,rstb,load,sin,din,pout);
  end
  
  
endmodule
  
