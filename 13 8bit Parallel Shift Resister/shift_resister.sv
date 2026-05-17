//parallel load shift resister


module shift_resister(input clk,input rstb,input load,input sin,input [7:0]din,output reg [7:0]pout);
  
  always @(posedge clk or negedge rstb) begin
    if (!rstb) pout<=8'b00000000;
    else if (load) pout<=din;
    else pout<={sin,pout[7:1]};
    
  end
  
endmodule
