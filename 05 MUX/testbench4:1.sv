module tb;
  reg a,b,c,d;
  reg [1:0]sel;
  wire y;
  
  MUX4to1 u1(a,b,c,d,sel,y);
  
  
  initial begin
    sel =2'b00; a=1; b=0; c=0; d=0;
    #10;
    sel =2'b01; a=0; b=1; c=0; d=0;
    #10;
    sel =2'b10; a=0; b=0; c=1; d=0;
    #10;
    sel =2'b11; a=0; b=0; c=0; d=1;
    #10;
    sel =2'b00; a=0; b=1; c=1; d=1;
    #10;
    sel =2'b01; a=1; b=0; c=1; d=1;
    #10;
    sel =2'b10; a=1; b=1; c=0; d=1;
    #10;
    sel =2'b11; a=1; b=1; c=1; d=0;
    #10;
    
    $finish;
  end
  
  initial begin
    $monitor("Time=%0t sel=%b a=%b b=%b c=%b d=%b y=%b",$time,sel,a,b,c,d,y);
  end
  
endmodule
