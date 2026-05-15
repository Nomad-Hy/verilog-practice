module decoder_assign #(parameter N=2) (input [N-1:0]in, output [2**N-1:0]out );
  
  assign out=1<<in;
  
endmodule
