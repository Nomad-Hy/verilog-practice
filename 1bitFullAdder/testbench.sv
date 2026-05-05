module tb;
    // 입력은 reg, 출력은 wire
    reg  a, b, cin;
    wire sum, cout;
    
    // 회로 인스턴스화
    full_adder_1bit u1 (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    // 테스트 시나리오 
    initial begin
        a=0; b=0; cin=0; #10;
        a=0; b=0; cin=1; #10;
        a=0; b=1; cin=0; #10;
        a=0; b=1; cin=1; #10;
        a=1; b=0; cin=0; #10;
        a=1; b=0; cin=1; #10;
        a=1; b=1; cin=0; #10;
        a=1; b=1; cin=1; #10;
        $finish;
    end
    
    // 결과 출력
    initial begin
        $monitor("Time=%0t | a=%b b=%b cin=%b | sum=%b cout=%b", 
                 $time, a, b, cin, sum, cout);
    end
endmodule
