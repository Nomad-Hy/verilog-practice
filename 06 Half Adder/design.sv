module half_adder(input a,input b,output reg sum,output reg carry);
  
  always @ (a,b)begin
    
    sum=a^b;
    carry=a&b;
  end
endmodule
