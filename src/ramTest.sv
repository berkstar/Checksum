`timescale 1ns / 1ps


module ramTest();

logic clk,writeE,reset;
logic [3:0] adr;
logic [7:0] din,dout;

ram ram(clk, writeE,reset,adr,din,dout);



    always
        begin 
            clk = 1;#5;clk = 0;#5;
    end

initial begin


writeE = 1;
adr = 4'b0000;
din = 8'b1000_0000;
#20;
writeE = 0;
#20;
adr = 4'b0001;

#20;
adr = adr -1;
#20;
adr = adr -1;
#20;
adr = adr -1;

#20;
adr = adr +1;
#20;
adr = adr +1;
#20;
adr = adr +1;
#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;

#20;
adr = adr +1;
#20;
adr = adr +1;
#20;
adr = adr +1;
#20;
adr = adr +1;

end


endmodule
