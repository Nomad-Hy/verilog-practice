`timescale 1ns/1ps

module flipflop_tb;
  
  reg d,clk,resetn;
  wire q;
  
  dflipflop instance1(.d(d),.clk(clk),.resetn(resetn),.q(q));
  
  
    
  initial clk=1'b0;
  
  always  #5 clk=~clk;
 
  
  
	initial begin
    
    $dumpfile("test_result.vcd");
    $dumpvars(0);
    
    // 1단계: Reset 활성 
        resetn = 0; d = 0;
        #15;
        
        // 2단계: Reset 해제, d=1 → 다음 엣지에 q=1
        resetn = 1; d = 1;
        #10;
        
        // 3단계: d=0
        d = 0;
        #10;
        
        // 4단계: d 변화
        d = 1; #5;
        d = 0; #5;
        d = 1; #10;
        
        // 5단계: 비동기 reset 다시 (즉시 q=0)
        d = 1; resetn = 0;
        #10;
        
        // 6단계: Reset 해제
        resetn = 1; d = 0;
        #20;
    
    $finish;
    end
  
  
	initial begin
      
      $monitor("Time:%0t d=%b resetn=%b clk=%b q=%b",$time,d,resetn,clk,q);
      
    end
  
  
  always @(posedge clk) begin
    
    #1;
    if(resetn)begin
      if(q!==1'b0)
        $error("RESET FAIL: resetn=1 but q=%b at time %0t", q, $time);
      
endmodule
    
