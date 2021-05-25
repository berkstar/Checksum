`timescale 1ns / 1ps

module timerTest();

logic clk,load,enable, pulse;
logic [30:0] qtime;


timer tim(clk,load,enable, qtime,pulse );

    always
        begin 
            clk = 1;#5;clk = 0;#5;
    end


initial begin

qtime = 3;

load = 1;

#10;

load = 0;

enable =1;



end

endmodule
