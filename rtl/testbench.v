`timescale 1ps/1ps

module testbench();

    reg clk,RSTn;
    reg[3:0] col;

    BuzzerSoC core(
        .clk(clk),
        .RSTn(RSTn),
        .SWCLK(1'b0),
        .col(col)
    );

    always  #5 clk = ~clk;

    initial begin
        clk = 0;
        RSTn = 0;
        col = 4'b1111;
        #10;
        RSTn = 1;
        col = 4'b1111;
    end
endmodule