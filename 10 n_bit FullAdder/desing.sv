//1bit full adder

module fulladder_1bit(input a,input b,input cin,output cout,output sum);
  
  assign {cout,sum}=a+b+cin;
  
endmodule




module fulladder_nbit #(parameter N=4) (input [N-1:0]a,input [N-1:0]b, input cin, output cout, output [N-1:0]sum);
  
  genvar i;
  wire [N:0]carry;
  
  assign carry[0]=cin;
  assign cout=carry[N];
  
  generate
    
    for(i=0;i<N;i=i+1) begin : fa_loop
  		
      fulladder_1bit instances(.a(a[i]),.b(b[i]),.cin(carry[i]),.cout(carry[i+1]),.sum(sum[i]));
    end
    
  endgenerate
  
endmodule
