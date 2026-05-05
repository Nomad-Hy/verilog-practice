module Mux2to1(input a, input b,input sel,output reg y);
  
  always @ (a,b,sel)begin
    
    case(sel)
      1'b1:y=a;
      1'b0:y=b;
      
    endcase
  end
endmodule
