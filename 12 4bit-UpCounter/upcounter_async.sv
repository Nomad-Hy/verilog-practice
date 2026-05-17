module tb_counter;
  
  reg clk,rstb;
  wire [3:0]cnt;
  
  
  upcounter_async instance1(.clk(clk),.rstb(rstb),.cnt(cnt));
  
  initial clk=1'b0;
  
  always #5 clk=~clk;
  
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_counter);
  	
    rstb=1'b0; #20;
              
              
   	rstb=1'b1;
    
    #200;
	$display("-----------Simulation End----------");
	$finish;
              
  end         
  
  
  initial begin
    
    $monitor("Time=%0t ,clk=%b, rstb=%b, cnt=%b",$time,clk,rstb,cnt);
    
  end
  
  
    endmodule
