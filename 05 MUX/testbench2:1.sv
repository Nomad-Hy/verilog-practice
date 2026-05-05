module tb;
    reg a, b, sel;
    wire y;
    
    Mux2to1 u1 (.a(a), .b(b), .sel(sel), .y(y));
    
    initial begin
        a = 0; b = 1; sel = 0; #10;  // y는 a (=0)
        sel = 1; #10;                  // y는 b (=1)
        a = 1; b = 0; sel = 0; #10;  // y는 a (=1)
        sel = 1; #10;                  // y는 b (=0)
        $finish;
    end
    
    initial begin
        $monitor("Time=%0t a=%b b=%b sel=%b y=%b", $time, a, b, sel, y);
    end
endmodule
