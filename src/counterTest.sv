`timescale 1ns / 1ps


module counterTest();


//module counter(input logic clk,countEnable,clear,output logic [15:0] count);


logic countEnable,clk,clear;
logic [15:0] count;


    always
        begin 
            clk = 1;#5;clk = 0;#5;
    end


counter c(clk,countEnable,clear,count);

initial begin
#20;
countEnable = 1;
#20;
clear =1;
#20;
clear = 0;
#20;
countEnable = 1;
#20;


end



endmodule
