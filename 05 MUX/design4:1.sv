//4:1MUX

module MUX4to1(input a,input b,input c,input d,input [1:0]sel,output reg y);
  
  always @(a,b,c,d,sel) begin
    
    case(sel)
      
      2'b00:y=a;
      2'b01:y=b;
      2'b10:y=c;
      2'b11:y=d;
      
    endcase
  end
endmodule
