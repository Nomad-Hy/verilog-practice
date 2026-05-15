`timescale 1ns / 1ps

module tb_fulladder_8bit;

    // 1. 비트 수를 8로 변경
    parameter N = 8;

    reg [N-1:0] t_a, t_b;
    reg t_cin;
    wire [N-1:0] t_sum;
    wire t_cout;

    // 2. DUT 호출 (N=8 전달)
    fulladder_nbit #(.N(N)) uut (
        .a(t_a), .b(t_b), .cin(t_cin), 
        .cout(t_cout), .sum(t_sum)
    );

    initial begin
        // 초기화
        t_a = 0; t_b = 0; t_cin = 0; #10;

        // 케이스 1: 중간값 덧셈 (100 + 50 = 150)
        t_a = 8'd100; t_b = 8'd50; t_cin = 0; #10;

        // 케이스 2: 8비트 최대값 직전 (128 + 127 = 255)
        // 8'b1000_0000 + 8'b0111_1111 = 8'b1111_1111
        t_a = 8'd128; t_b = 8'd127; t_cin = 0; #10;

        // 케이스 3: Carry Out 발생 (128 + 128 = 256 -> Cout=1, Sum=0)
        t_a = 8'd128; t_b = 8'd128; t_cin = 0; #10;

        // 케이스 4: 8비트 완전 최대값 (255 + 1 = 256 -> Cout=1, Sum=0)
        t_a = 8'hFF; t_b = 8'h01; t_cin = 0; #10;

        // 케이스 5: 모든 입력이 1인 경우 (255 + 255 + 1 = 511)
        // 결과: Cout=1, Sum=255(8'hFF)
        t_a = 8'hFF; t_b = 8'hFF; t_cin = 1; #10;

       
        $finish;
    end

    initial begin
        $monitor("Time:%0t | A=%3d B=%3d Cin=%b | Cout=%b Sum=%3d", 
                 $time, t_a, t_b, t_cin, t_cout, t_sum);
    end

endmodule
