`timescale 1ns / 1ps

module TestSeven();

logic a,b,clk,dp;
logic [6:0] seg;
logic [3:0] an;


Test test(a,b,clk,seg,dp,an);


    always
        begin 
            clk = 1;#5;clk = 0;#5;
    end


initial begin

a = 1;
#10;
a = 0;



end

endmodule
