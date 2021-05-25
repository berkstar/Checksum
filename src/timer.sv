`timescale 1ns / 1ps


module timer(input logic clk,load,enable,input logic [30:0] qtime,output logic pulse );


logic [30:0] next;


always_ff @(posedge clk)
    if (load | pulse) next <= qtime - 1 ;
    else if (enable) next <= next -1;
    
assign pulse = (next == 0 || next ==1 || next == 2);

endmodule

