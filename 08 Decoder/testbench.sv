module tb_assign;
  
  localparam N=2;
  
  reg [N-1:0]in;
  wire [2**N-1:0]out;
  
  integer i;
  
  
  decoder_assign #(.N(N)) u0(.in(in),.out(out));
  
  initial begin
    for(i=0;i<2**N;i=i+1) begin
      in=i; #10;
    end
    $finish;
    
  end
  
  
  initial begin
  $monitor("Time=%0t in=%b out=%b",$time,in,out);
  end
  
  
    
endmodule
