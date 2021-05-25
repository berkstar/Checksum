`timescale 1ns / 1ps


module bDBTest();

logic clk,butIn,butOut;


    always
        begin 
            clk = 1;#5;clk = 0;#5;
    end


bDebounce bounce(butIn,clk,butOut);
initial begin

butIn = 0;
#40;
butIn = 1;
#5;
butIn = 0;
#5;
butIn = 1;
#5;
butIn = 0;
#5;
butIn = 1;
#5;
butIn = 0;
#5;
butIn = 1;
#5;
butIn = 0;
#5;
butIn = 1;
#5;
butIn = 0;
#5;
butIn = 1;
#5;
butIn = 0;
#5;
butIn = 1;
#5;
butIn = 0;
#5;
butIn = 1;
#5;
butIn = 0;
#5;
butIn = 1;
#5;
butIn = 0;
#5;
butIn = 1;
#5;
butIn = 0;
#5;
butIn = 1;
#100;
butIn = 1;
#100;

end

endmodule