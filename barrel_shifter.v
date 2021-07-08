/****************************************

barrel_shifter module
Name    : Perera G K B H
ENo     : E/16/276

*****************************************/
`timescale 1s/100ms

module barrel_shifter(INPUT, SHIFT_AMNT, SHIFTOP, OUTPUT_DELAYED);

    //declare ports
    input [7:0] INPUT, SHIFT_AMNT;
    input [1:0] SHIFTOP;
    output [7:0] OUTPUT_DELAYED;

    //wires to connect components
    wire [7:0] REVERSED_INPUT, REVERSED_SHIFT, OUTPUT,SHIFT, DATA1;

    //giving a delay of two units
    assign #2 OUTPUT_DELAYED = OUTPUT;

    //reverse the input and shifted values by rereouting
    //this is done to obtain the left logical shift from right logical shift
    assign REVERSED_INPUT = {INPUT[0], INPUT[1], INPUT[2], INPUT[3], INPUT[4], INPUT[5], INPUT[6], INPUT[7]};
    assign REVERSED_SHIFT = {SHIFT[0], SHIFT[1], SHIFT[2], SHIFT[3], SHIFT[4], SHIFT[5], SHIFT[6], SHIFT[7]};

    //control signal to the reverse value selecting muxes
    wire REVERSE;
    //since the SHIFTOP for sll is 11, SHIFTOP is sent through an and gate to generate control for REVERSE selection
    and reverse_enable(REVERSE, SHIFTOP[1], SHIFTOP[0]);
    //muxes for reverse selection
    mux_2x1_8bit direction_muxin(INPUT, REVERSED_INPUT, DATA1, REVERSE);
    mux_2x1_8bit direction_muxout(SHIFT, REVERSED_SHIFT, OUTPUT, REVERSE);


    //mux level 1
    //this level of 8 muxes will shift the input to the right by 1 bit.
    //shift control is used to give the proper input to the newly added bit
    wire SHIFT_CONTROL_OUT1, mux_out10, mux_out11, mux_out12, mux_out13, mux_out14, mux_out15, mux_out16, mux_out17;

    shift_control shift_control1(DATA1[7], DATA1[0], SHIFTOP, SHIFT_CONTROL_OUT1);

    mux_2x1_1bit mux10(DATA1[0], DATA1[1], muxout_10, SHIFT_AMNT[0]);
    mux_2x1_1bit mux11(DATA1[1], DATA1[2], muxout_11, SHIFT_AMNT[0]);
    mux_2x1_1bit mux12(DATA1[2], DATA1[3], muxout_12, SHIFT_AMNT[0]);
    mux_2x1_1bit mux13(DATA1[3], DATA1[4], muxout_13, SHIFT_AMNT[0]);
    mux_2x1_1bit mux14(DATA1[4], DATA1[5], muxout_14, SHIFT_AMNT[0]);
    mux_2x1_1bit mux15(DATA1[5], DATA1[6], muxout_15, SHIFT_AMNT[0]);
    mux_2x1_1bit mux16(DATA1[6], DATA1[7], muxout_16, SHIFT_AMNT[0]);
    mux_2x1_1bit mux17(DATA1[7], SHIFT_CONTROL_OUT1, muxout_17, SHIFT_AMNT[0]);


    //mux level 2
    //this level of 8 muxes will shift the input to the right by 2 bits.
    //shift controls are used to give the proper inputs to the newly added bits
    wire SHIFT_CONTROL_OUT20, SHIFT_CONTROL_OUT21, muxout_20, muxout_21, muxout_22, muxout_23, muxout_24, muxout_25, muxout_26, muxout_27;

    shift_control shift_control20(DATA1[7], muxout_10, SHIFTOP, SHIFT_CONTROL_OUT20);
    shift_control shift_control21(DATA1[7], muxout_11, SHIFTOP, SHIFT_CONTROL_OUT21);

    mux_2x1_1bit mux20(muxout_10, muxout_12, muxout_20, SHIFT_AMNT[1]);
    mux_2x1_1bit mux21(muxout_11, muxout_13, muxout_21, SHIFT_AMNT[1]);
    mux_2x1_1bit mux22(muxout_12, muxout_14, muxout_22, SHIFT_AMNT[1]);
    mux_2x1_1bit mux23(muxout_13, muxout_15, muxout_23, SHIFT_AMNT[1]);
    mux_2x1_1bit mux24(muxout_14, muxout_16, muxout_24, SHIFT_AMNT[1]);
    mux_2x1_1bit mux25(muxout_15, muxout_17, muxout_25, SHIFT_AMNT[1]);
    mux_2x1_1bit mux26(muxout_16, muxout_10, muxout_26, SHIFT_AMNT[1]);
    mux_2x1_1bit mux27(muxout_17, muxout_11, muxout_27, SHIFT_AMNT[1]);

    //mux level 3
    //this level of 8 muxes will shift the input to the right by 4 bits.
    //shift controls are used to give the proper inputs to the newly added bits
    wire SHIFT_CONTROL_OUT30, SHIFT_CONTROL_OUT31, SHIFT_CONTROL_OUT32, SHIFT_CONTROL_OUT33;
    wire muxout_30,muxout_31,muxout_32,muxout_33,muxout_34,muxout_35,muxout_36,muxout_37;
    shift_control shift_control30(DATA1[7], muxout_20, SHIFTOP, SHIFT_CONTROL_OUT30);
    shift_control shift_control31(DATA1[7], muxout_21, SHIFTOP, SHIFT_CONTROL_OUT31);
    shift_control shift_control32(DATA1[7], muxout_22, SHIFTOP, SHIFT_CONTROL_OUT32);
    shift_control shift_control33(DATA1[7], muxout_23, SHIFTOP, SHIFT_CONTROL_OUT33);

    mux_2x1_1bit mux30(muxout_20, muxout_24, muxout_30, SHIFT_AMNT[2]);
    mux_2x1_1bit mux31(muxout_21, muxout_25, muxout_31, SHIFT_AMNT[2]);
    mux_2x1_1bit mux32(muxout_22, muxout_26, muxout_32, SHIFT_AMNT[2]);
    mux_2x1_1bit mux33(muxout_23, muxout_27, muxout_33, SHIFT_AMNT[2]);
    mux_2x1_1bit mux34(muxout_24, SHIFT_CONTROL_OUT30, muxout_34, SHIFT_AMNT[2]);
    mux_2x1_1bit mux35(muxout_25, SHIFT_CONTROL_OUT31, muxout_35, SHIFT_AMNT[2]);
    mux_2x1_1bit mux36(muxout_26, SHIFT_CONTROL_OUT32, muxout_36, SHIFT_AMNT[2]);
    mux_2x1_1bit mux37(muxout_27, SHIFT_CONTROL_OUT33, muxout_37, SHIFT_AMNT[2]);

    // //mux level 4
    //this level of 8 muxes will shift the input to the right by 8 bits.
    //shift controls are used to give the proper inputs to the newly added bits
    wire SHIFT_CONTROL_OUT40, SHIFT_CONTROL_OUT41, SHIFT_CONTROL_OUT42, SHIFT_CONTROL_OUT43,SHIFT_CONTROL_OUT44, SHIFT_CONTROL_OUT45, SHIFT_CONTROL_OUT46, SHIFT_CONTROL_OUT47;
    shift_control shift_control40(DATA1[7], muxout_30, SHIFTOP, SHIFT_CONTROL_OUT40);
    shift_control shift_control41(DATA1[7], muxout_31, SHIFTOP, SHIFT_CONTROL_OUT41);
    shift_control shift_control42(DATA1[7], muxout_32, SHIFTOP, SHIFT_CONTROL_OUT42);
    shift_control shift_control43(DATA1[7], muxout_33, SHIFTOP, SHIFT_CONTROL_OUT43);
    shift_control shift_control44(DATA1[7], muxout_34, SHIFTOP, SHIFT_CONTROL_OUT44);
    shift_control shift_control45(DATA1[7], muxout_35, SHIFTOP, SHIFT_CONTROL_OUT45);
    shift_control shift_control46(DATA1[7], muxout_36, SHIFTOP, SHIFT_CONTROL_OUT46);
    shift_control shift_control47(DATA1[7], muxout_37, SHIFTOP, SHIFT_CONTROL_OUT47);

    mux_2x1_1bit mux40(muxout_30, SHIFT_CONTROL_OUT40, SHIFT[0], SHIFT_AMNT[3]);
    mux_2x1_1bit mux41(muxout_31, SHIFT_CONTROL_OUT41, SHIFT[1], SHIFT_AMNT[3]);
    mux_2x1_1bit mux42(muxout_32, SHIFT_CONTROL_OUT42, SHIFT[2], SHIFT_AMNT[3]);
    mux_2x1_1bit mux43(muxout_33, SHIFT_CONTROL_OUT43, SHIFT[3], SHIFT_AMNT[3]);
    mux_2x1_1bit mux44(muxout_34, SHIFT_CONTROL_OUT44, SHIFT[4], SHIFT_AMNT[3]);
    mux_2x1_1bit mux45(muxout_35, SHIFT_CONTROL_OUT45, SHIFT[5], SHIFT_AMNT[3]);
    mux_2x1_1bit mux46(muxout_36, SHIFT_CONTROL_OUT46, SHIFT[6], SHIFT_AMNT[3]);
    mux_2x1_1bit mux47(muxout_37, SHIFT_CONTROL_OUT47, SHIFT[7], SHIFT_AMNT[3]);

endmodule


//this module determines the proper value to be given to the newly added bit which is determined by combinational logic.
//if arithmatic shift then the newly added bit is most significant bit ot the input
//if logical shift then the newly added bit is 0
//if rotate then newly added bit is the shifted bit
module shift_control(MSB,IN, SHIFTOP, OUT);
    //declare ports
    input IN, MSB;
    input [1:0] SHIFTOP;
    output OUT;

    wire SHIFTOP0_NOT, SHIFTOP1_NOT;
    
    //combinational circuit
    not mynot1(SHIFTOP0_NOT, SHIFTOP[0]);
    not mynot1(SHIFTOP1_NOT, SHIFTOP[1]);

    and myand1(AND1_OUT, IN, SHIFTOP[1], SHIFTOP0_NOT);
    and myand2(AND2_OUT, MSB, SHIFTOP1_NOT, SHIFTOP[0]);

    or myor(OUT,AND1_OUT,AND2_OUT);
    
endmodule