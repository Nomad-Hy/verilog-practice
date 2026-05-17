module tb_counter;
  
  reg clk,en,rstb;
  wire [3:0]cnt;
  
  upcounter_sync instance1(.clk(clk),.en(en),.rstb(rstb),.cnt(cnt));
 
  initial clk=1'b0;
  
  always #5 clk=~clk;
  
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_counter);
    
    rstb=1'b0;
    en=1'b0;
    
    #20;
    
    rstb=1'b1;
    #20;
    
    en=1'b1;
    #30;
    
    en=1'b1;
    #100;
    
    rstb=1'b0;
    #10;
    rstb=1'b1;
    en=1'b1;
    #50;
    
    $display("----simulation finish----");
    $finish;
    
  end
  
  initial begin
    $monitor("Time=%0t, clk=%b, en=%b, rstb=%b, cnt=%b",$time,clk,en,rstb,cnt);
  end
  
  
  
  
endmodule
