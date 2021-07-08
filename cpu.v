/****************************************
cpu module
Name    : Perera G K B H
ENo     : E/16/276

*****************************************/
`timescale 1s/100ms

//include the necessary files
`include "control_unit.v"
`include "reg_file.v"
`include "alu.v"
`include "other_components.v"


module cpu(INST_ADDRESS, INSTRUCTION, CLK, RESET, ALU_OUT, OUT1_REG, READ, WRITE, BUSYWAIT, DATA_READDATA);
    
    // declare the ports
    input [31:0] INSTRUCTION;
    input CLK, RESET, BUSYWAIT;
    input [7:0] DATA_READDATA;
    output [7:0] OUT1_REG, ALU_OUT;
    output READ, WRITE;
    output [9:0] INST_ADDRESS;

    //wires declared to connect the components
    wire WRITEENABLE,SUBSTRACT_SELECT,IMMEDIATE_SELECT, BRANCHEQ, BRANCHNE, JUMP, WRITEACCESS;
    wire [2:0] ALUOP;
    wire [1:0] SHIFTOP;
    wire [7:0] OUT1_REG,OUT2_REG,ALU2_IN, MUX_OUT, ALU_OUT , COMPLEMENT_OUT, REGIN;
    wire [31:0] PC;

    //assign only the lest significant 10 bits of the PC to be sent to the instruction cache
    assign INST_ADDRESS = PC[9:0];

    //wires to connect componets
    wire [31:0] PC_IN, PC_NEXT, PC_JUMP, PC_SHIFTED;
    reg [31:0] PC_EXTENDED;

    //reg to store the incriment value
    reg [31:0] INCRIMENT_VAL = 32'd4;

    //performing sign extension by re-routing
    integer i;
    always @(INSTRUCTION) begin
        PC_EXTENDED [7:0] = INSTRUCTION[23:16];
        //connecting the most significant bit to extended bits
        for (i = 8; i < 32; i = i + 1) begin
            PC_EXTENDED[i] = INSTRUCTION[23];
        end
    end

    //left shifting by re-routing
    assign PC_SHIFTED = {PC_EXTENDED[30:0],2'b00};

    //combinational circuit to generate proper control signals to the pc_src_mux
    //wires declared to connect components
    wire ZERO,PC_SRC_SELECT,ANDEQ_OUT,ANDNE_OUT, ZERO_INVERT;
    //invert the ZERO from alu to be usind in bne instructions
    not zero_not(ZERO_INVERT, ZERO);

    //and the inverted zero and branchne control.
    //output 1 only when both are 1
    and branchne_and(ANDNE_OUT, ZERO_INVERT, BRANCHNE);

    //and zero and brancheq control
    //output 1 only when both are 1
    and brancheq_and(ANDEQ_OUT, ZERO, BRANCHEQ);

    //or the two outputs from ands and the jump control
    or jump_or(PC_SRC_SELECT, ANDEQ_OUT,ANDNE_OUT, JUMP);

    //select the input to the program counter
    //when the select is 1 then pc_jump is connected else pc_next(pc + 4) is connected
    mux_2x1_32bit pc_src_mux(PC_NEXT, PC_JUMP, PC_IN, PC_SRC_SELECT);

    //pc jump calculator
    //pc_next value is added to the offset(pc_shifted) and pc_jump is calculated
    adder_32bit_delay2 pc_jump_calculator(PC_SHIFTED, PC_NEXT, PC_JUMP);

    //program counter register
    //this register stores the pc value
    //inputs are pc_in(incrimented value from the pc_adder), reset, busywait
    //outputs are pc_out(stored value in the program_counter)
    register_32bit program_counter(PC_IN, PC, RESET, CLK, BUSYWAIT);

    //adder to incriment the program counter value
    //inputs are pc_out(stored pc value from the program_counter), incriment value which is 4
    //outputs are pc_in(input value to the program counter)
    adder_32bit_delay1 pc_incrimenter(PC, INCRIMENT_VAL, PC_NEXT);

    //control unit
    //inputs are instruction, reset, clk
    //outputs are writeenable, substract_select, immediate_select, aluop, pc, read, write
    control_unit main_control(INSTRUCTION, WRITEENABLE, SUBSTRACT_SELECT, IMMEDIATE_SELECT, BRANCHEQ,BRANCHNE, JUMP, ALUOP, SHIFTOP, READ, WRITE);

    //register file
    //inputs are [18:16] of the instruction(inaddress),[10:8] of the instruction(out2address),
        //[2:0] of the instruction(out1address), regin(value from the regin_src_mux), writeaccess(result form the and gate), clk, reset
    //outputs are out1_reg(out1), out2_reg(out2)
    reg_file myregister(REGIN, OUT1_REG, OUT2_REG, INSTRUCTION[18:16], INSTRUCTION[10:8], INSTRUCTION[2:0], WRITEACCESS, CLK, RESET);

    //alu
    //inputs are aluop(generated from the control unit),out1_reg(from the register file),
        //alu2_in(from the immediate selecting mux),shiftop
    //outputs are alu_out(result of the alu), zero
    alu myalu(OUT1_REG, ALU2_IN, ALUOP, SHIFTOP, ALU_OUT,ZERO);

    //immediate selecting mux
    //inputs are [7:0] of the instruction, mux_out(from the 2s complement selecting mux), immediate_select(from the control unit)
    //outputs are alu2_in(input to the alu data 2 port)
    mux_2x1_8bit mux_immediate(MUX_OUT, INSTRUCTION[7:0], ALU2_IN, IMMEDIATE_SELECT);

    //2s complement selecting mux
    //inputs are out2_reg(from the registerfile), complement_out(from the 2s complement module), sustract_select(from the control unit)
    //outputs are mux_out(input to the immediate selecting mux)
    mux_2x1_8bit mux_substract(OUT2_REG, COMPLEMENT_OUT, MUX_OUT, SUBSTRACT_SELECT);

    //2s complement generating module
    //inputs are out2_reg(from the register file)
    //outputs are complement_out(inut to the 2s complement selecting mux)
    complement2s mycomplement2s(OUT2_REG, COMPLEMENT_OUT);

    //mux to select the data to be sent to register file write
    mux_2x1_8bit reg_in_src_mux(ALU_OUT, DATA_READDATA, REGIN, READ);

    //combinational circuit to stall the register file write
    //writeenable signal in the register file is stalled when the busy wait is 0
    assign WRITEACCESS = WRITEENABLE & (!BUSYWAIT);

endmodule