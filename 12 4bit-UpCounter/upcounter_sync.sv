module upcounter_sync(input clk,input en,input rstb,output reg [3:0]cnt);
  
  
  always @ (posedge clk or negedge rstb)begin
    
    if (!rstb) cnt<=4'b0000;
    else if(en) begin
      if(cnt!=4'b1111) cnt<=cnt+1;
      else cnt<=4'b0000;
    end
    
  end
  
endmodule
