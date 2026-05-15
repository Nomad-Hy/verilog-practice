module tb_comparator;
  
  reg [3:0]a,b;
  wire gt,lt,eq;
  
  comparator_4bit u0(.a(a),.b(b),.gt(gt),.lt(lt),.eq(eq));
  
  initial begin
    
  	a = 4'b0000; b = 4'b0000; #10;    // a == b (0 == 0)
    a = 4'b0101; b = 4'b0101; #10;    // a == b (5 == 5)
    a = 4'b1111; b = 4'b1111; #10;    // a == b (15 == 15)
    a = 4'b1111; b = 4'b1011; #10;    // a > b  (15 > 11)
    a = 4'b1000; b = 4'b0001; #10;    // a > b  (8 > 1)
    a = 4'b0011; b = 4'b1100; #10;    // a < b  (3 < 12)
    a = 4'b0000; b = 4'b1111; #10;    // a < b  (0 < 15)
    $finish;
  end
  
  
  always @ (*) begin
    
    if (gt!==(a>b)) $error("GT logic error!");
    else if (lt!==(a<b)) $error("LT logic error!");
    else if(eq!==(a==b))  $error("EQ logic error!");   
    else $display("Test passed");
  end
  
endmodule
