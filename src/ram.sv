`timescale 1ns / 1ps


module ram(input logic clk, writeE,reset,input logic [3:0] adr,input logic [7:0] din,output logic [7:0] dout);

logic [7:0] tmp [15:0];

always_ff @(posedge clk)
    if (reset) 
    begin
        tmp[0] <= 0;
        tmp[1] <= 1;
        tmp[2] <= 2;
        tmp[3] <= 3;
        tmp[4] <= 4;
        tmp[5] <= 5;
        tmp[6] <= 6;
        tmp[7] <= 7;
        tmp[8] <= 8;
        tmp[9] <= 9;
        tmp[10] <= 10;
        tmp[11] <= 11;
        tmp[12] <= 12;
        tmp[13] <= 13;
        tmp[14] <= 14;
        tmp[15] <= 15;
    end
    else if (writeE) tmp[adr] <= din;

assign dout = tmp[adr];



endmodule
