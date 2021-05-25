`timescale 1ns / 1ps


module bDebounce(input logic butIn,clk, output logic butOut);

localparam S_INIT = 3'b000,
            S_WAIT_BIN = 3'b001,
            S_SIGNAL_1 = 3'b010,
            S_SIGNAL_0 = 3'b011,
            S_HOLD = 3'b100;
           
logic [2:0] state,nextstate;
logic enableReg1,enableReg2,loadReg;
logic [30:0] qtimeReg1,qtimeReg2;
//input logic clk,load,enable,input logic [30:0] qtime,output logic pulse

timer timer1(clk,loadReg,enableReg1,qtimeReg1,pulse1);
timer timer2(clk,loadReg,enableReg2,qtimeReg2,pulse2);



         
always_ff @(posedge clk)
    state <= nextstate;

            
            
always_comb
    case (state)
    S_INIT: begin
        qtimeReg1 = 100;
        qtimeReg2 = 20000000;
        loadReg = 1;
        enableReg1 = 0;
        enableReg2 = 0;
        nextstate = S_WAIT_BIN;
        end
    S_WAIT_BIN: begin
        loadReg = 0;
        if (butIn)  nextstate = S_SIGNAL_1;
        else    nextstate = S_WAIT_BIN;
        end
    S_SIGNAL_1:  begin
        enableReg1 = 1;
        if (pulse1) nextstate = S_SIGNAL_0;
        else  nextstate = S_SIGNAL_1;
    end
    S_SIGNAL_0: begin
         enableReg2 = 1;
        if (pulse2)  nextstate = S_HOLD;
        else    nextstate = S_SIGNAL_0;
    end
    S_HOLD: begin
         enableReg1 = 0;
         enableReg1 = 0;
        if (butIn)  nextstate = S_SIGNAL_1;
        else    nextstate = S_HOLD;
    end
        
    default:    nextstate = S_INIT;
    endcase
    
    


assign butOut = (state == S_SIGNAL_1);



endmodule
