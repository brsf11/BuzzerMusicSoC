`timescale 1ps/1ps

module testbench();

    reg clk,RSTn;

    BuzzerSoC core(
        .clk(clk),
        .RSTn(RSTn),
        .SWCLK(1'b0)
    );

    always  #5 clk = ~clk;

    initial begin
        clk = 0;
        RSTn = 0;
        #10;
        RSTn = 1;
    end
endmodule