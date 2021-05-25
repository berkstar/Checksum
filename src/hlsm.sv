`timescale 1ns / 1ps


module hlsm(input logic clk,bbReset,bbRun,bbPrevData,bbNextData,bbEnter,bbDisplay,input logic [3:0] sAdress, input logic [7:0] sData,
output logic [7:0] dataLeds, output logic [3:0] adressLeds, output logic dp,output logic [6:0] seg,output logic [3:0] an);



//States
localparam S_INIT = 5'd0,
            S_ENTER_DATA = 5'd1,
            S_DISPLAY = 5'd2,
            S_ENTER_DATA_E = 5'd3,
            S_ENTER_DATA_D = 5'd4,
            S_NEXT_DATA = 5'd5,
            S_PREV_DATA = 5'd6,
            S_DATA_RELEASE = 5'd7,
            S_SUM_INIT = 5'd8,
            S_SUM_WAIT = 5'd9,
            S_SUM_ADD = 5'd10,
            S_SUM_COMP = 5'd11,
            S_SUM_HOLD = 5'd12,         
            S_SUM_DISPLAY = 5'd13,
            S_SUM_ADDRESS = 5'd14,
            S_SUM_WAIT_10 = 5'd15,
            S_COUNT_WAIT = 5'd16,
            S_COUNT_DISPLAY =5 'd17;

 
           
logic [4:0] state,nextstate;
logic [3:0] sAdressReg;
logic [3:0] lastAdressReg;
logic [4:0] in0,in1,in2,in3;
logic writeE;
logic [7:0] sDataReg,dout;
logic [7:0] sum;
logic[30:0] qTime;
logic tLoad, tEnable, tPulse;
logic [15:0] countTime;


int count;
logic countEnable,clear;


counter counter(clk,countEnable,clear,countTime);
timer timer(clk,tLoad,tEnable,qTime,tPulse);

//module ram(input logic clk, writeE,reset,input logic [3:0] adr,input logic [7:0] din,output logic [7:0] dout);
//module timer(input logic clk,load,enable,input logic [30:0] qtime,output logic pulse );

bDebounce bounceZero(bbReset,clk,bReset);
bDebounce bounceOne(bbEnter,clk,bEnter);
bDebounce bounceTwo(bbRun,clk,bRun);
bDebounce bounceThree(bbPrevData,clk,bPrevData);
bDebounce bounceFour(bbNextData,clk,bNextData);
bDebounce bounceFive(bbDisplay,clk,bDisplay);


//module compCalculator(input logic clk,checkSum_en,input logic [7:0] data [15:0],output logic [7:0] sum,output logic [15:0] countTime);


ram ram(clk,writeE,bReset,sAdressReg,sDataReg,dout);

sevenSeg seven(clk,in0,in1,in2,in3,seg,dp,an);



//State Register
always_ff @(posedge clk)begin
    state <= nextstate;
    end

            
//State Transition
always_ff @(negedge clk)
    case (state)
    S_INIT: begin
        qTime = 30'd1_000_000_000;
        lastAdressReg = 4'b0000;
        tLoad = 1;
        writeE = 0;
        nextstate = S_DISPLAY; 
    end
    S_DISPLAY:  begin
        tLoad = 0;
        in3 = {1'b0,lastAdressReg[3:0]};
        in2 = 5'd16;
        in1 = {1'b0,dout[7:4]};
        in0 = {1'b0,dout[3:0]};
        writeE = 0;

        if (bEnter)    nextstate = S_ENTER_DATA_E;
        else if (bRun)   nextstate = S_SUM_INIT;
        else if (bDisplay)  nextstate = S_COUNT_WAIT;
        else if(bPrevData)  nextstate = S_PREV_DATA;
        else if(bNextData)  nextstate = S_NEXT_DATA;
        else nextstate = S_DISPLAY;
    end

    S_SUM_INIT:begin
        sAdressReg = 4'b0000;
        sum = 8'b0000_0000;
        count = 0;
        clear = 1;
        nextstate = S_SUM_WAIT;
    end
    S_SUM_WAIT:begin
        clear = 0;
        nextstate = S_SUM_ADDRESS;

    end
    S_SUM_ADDRESS:begin
        if (count <= 15)begin
           countEnable = 1;
           sAdressReg = sAdressReg + 1;
           count = count + 1;
           nextstate = S_SUM_ADD;
       end
       else nextstate = S_SUM_COMP;
       end
       
    S_SUM_ADD:begin
 
           sum = sum + dout;
              nextstate = S_SUM_ADDRESS;

    end
    S_SUM_COMP: begin
        sum = ~sum + 1;
        nextstate = S_SUM_HOLD;
    end
    S_SUM_HOLD:begin
        countEnable = 0;
        nextstate = S_SUM_DISPLAY;
    end
    
    S_SUM_DISPLAY:begin
        tEnable = 1;
        in3 = 5'hC;
        in2 = 5'd17;
        in1 = {1'b0,sum[7:4]};
        in0 = {1'b0,sum[3:0]};
        if (tPulse)    nextstate = S_SUM_WAIT_10;
        else    nextstate = S_SUM_DISPLAY;
    end
    S_SUM_WAIT_10:begin
        tEnable = 0;
        nextstate = S_DISPLAY;
    end
        S_SUM_WAIT_10:begin
        tEnable = 1;
        in3 = 5'hC;
        in2 = 5'd17;
        in1 = {1'b0,sum[7:4]};
        in0 = {1'b0,sum[3:0]};
        if (tPulse)    nextstate = S_SUM_DISPLAY;
        else    nextstate = S_SUM_WAIT_10;
    end
    S_SUM_DISPLAY:begin
        tEnable = 0;
        nextstate = S_DISPLAY;
    end
        S_COUNT_WAIT:begin
        tEnable = 1;
        in3 = 5'h0;
        in2 = 5'd0;
        in1 = {1'b0,countTime[7:4]};
        in0 = {1'b0,countTime[3:0]};
        if (tPulse)    nextstate = S_COUNT_DISPLAY;
        else    nextstate = S_COUNT_WAIT;
    end
    S_COUNT_DISPLAY:begin
        tEnable = 0;
        nextstate = S_DISPLAY;
    end
    
    
    
    
    S_NEXT_DATA:  begin
        lastAdressReg = lastAdressReg + 1;
        
        writeE = 0;
         nextstate = S_DATA_RELEASE;

    end
    S_PREV_DATA:  begin
        lastAdressReg = lastAdressReg - 1;
        writeE = 0;
        nextstate = S_DATA_RELEASE;
    end
    S_DATA_RELEASE:  begin
        sAdressReg = lastAdressReg;
        if (bPrevData || bNextData) nextstate = S_DATA_RELEASE;
        else if (~bPrevData && ~bNextData) nextstate = S_DISPLAY;
    end



    
    S_ENTER_DATA_E: begin
writeE = 0;
        nextstate = S_ENTER_DATA;
    end
    S_ENTER_DATA_D: begin
    writeE = 0;
        sAdressReg = lastAdressReg;
        nextstate = S_DISPLAY;
    end
    S_ENTER_DATA:   begin
    
        sAdressReg = sAdress;
        sDataReg = sData;
        writeE = 1;
        
        
        nextstate = S_ENTER_DATA_D;
    end
    default:    nextstate = S_INIT;
   
endcase
    
    


// To show input to user data from switchs to leds.
assign adressLeds = sAdress;
assign dataLeds = sData;



endmodule
