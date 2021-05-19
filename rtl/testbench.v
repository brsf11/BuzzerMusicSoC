`timescale 1ps/1ps

module testbench();

    reg clk,RSTn;
    reg[3:0] row;

    BuzzerSoC core(
        .clk(clk),
        .RSTn(RSTn),
        .SWCLK(1'b0),
        .row(row)
    );

    always  #5 clk = ~clk;

    initial begin
        clk = 0;
        RSTn = 0;
        row = 4'b1111;
        #10;
        RSTn = 1;
        row = 4'b1110;
    end
endmodule