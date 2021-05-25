`timescale 1ns / 1ps

module counter(input logic clk,countEnable,clear,output logic [15:0] count);

always_ff @(posedge clk)
    if  (clear) count <= 16'd0;
    else if (countEnable) count <= count + 1;

endmodule
