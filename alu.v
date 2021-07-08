/****************************************
ALU module
Name    : Perera G K B H
ENo     : E/16/276

*****************************************/
`include "barrel_shifter.v"
`include "multiplier.v"
`timescale 1s/100ms

module alu( DATA1, DATA2, ALUOP, SHIFTOP, RESULT,ZERO);

    //port declaration
    input [7:0] DATA1, DATA2;
    input [2:0] ALUOP;
    input [1:0] SHIFTOP;
    output reg [7:0] RESULT;
    output ZERO;

    //wires declared to connect modules
    wire [7:0] SHIFT_RESULT, PRODUCT;

    //result is passed through a nor gate to generate the zero signal
    nor zero_nor(ZERO, RESULT[0], RESULT[1], RESULT[2], RESULT[3], RESULT[4], RESULT[5], RESULT[6], RESULT[7]);

    //barrel shifter
    //this always shifts the data1 by data2, but alu output is connected only when matching ALUOP is recieved
    barrel_shifter mybarrelshifter(DATA1, DATA2, SHIFTOP, SHIFT_RESULT);

    //multiplier
    //this always multiply the data1 by data2, but alu output is connected only when matching ALUOP is recieved
    multiplier mymultiplier(DATA1, DATA2, PRODUCT);

    wire [7:0] SUM, FORWARD, AND, OR;

    assign #1 FORWARD = DATA2;
    assign #2 SUM = DATA1 + DATA2;
    assign #1 AND_OUT =  DATA1 & DATA2;
    assign #1 OR_OUT = DATA1 | DATA2;

    always @ (*) begin
        case (ALUOP)
        //alu function forward
        3'b000 : RESULT = FORWARD;
        //alu function add
        3'b001 :  RESULT =  SUM;
        //alu function and
        3'b010 :  RESULT = AND_OUT;
        //alu function or
        3'b011 :  RESULT = OR_OUT;
        // alu fucntion for shift operations
        3'b100 : RESULT = SHIFT_RESULT;
        //alu function for mult
        3'b101 : RESULT = PRODUCT;
        // for functions to be implemented in the future
        default : RESULT = 8'b0000_0000;
        endcase
    end

endmodule