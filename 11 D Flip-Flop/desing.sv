module dflipflop(input d, input clk, input reset, output reg q);
  
  
  always @(posedge clk or negedge resetn) begin
    
    if (!resetn) q<=1'b0;
    
    else q<=d;
    
  end
  
endmodule

