/****************************************
control_unit module
Name    : Perera G K B H
ENo     : E/16/276

*****************************************/
`timescale 1s/100ms

module control_unit(INSTRUCTION, WRITEENABLE, SUBSTRACT_SELECT, IMMEDIATE_SELECT, BRANCHEQ, BRANCHNE, JUMP, ALUOP, SHIFTOP, READ, WRITE);

    //declare ports
    input [31:0] INSTRUCTION;
    output reg WRITEENABLE, SUBSTRACT_SELECT, IMMEDIATE_SELECT,BRANCHEQ, BRANCHNE, JUMP, READ, WRITE;
    output reg [2:0] ALUOP; 
    output reg [1:0] SHIFTOP;

    //derive the control signals from the INSTRUCTION
    always @ (INSTRUCTION) begin
        #1
        //read and write control signals are set so 0 to handle the case when two store or load signals excute one after the other
        READ = 1'b0;
        WRITE = 1'b0;

        case (INSTRUCTION[31:24])
            //loadi opcode
            8'b0000_0000: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b1;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b000;
            end
            //mov opcode
            8'b0000_0001: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b000;
            end
            //add opcode
            8'b0000_0010: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b001;
            end
            //substract opcode
            8'b0000_0011: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b1;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b001;
            end
            //and opcode
            8'b0000_0100: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b010;
            end
            //or opcode
            8'b0000_0101: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b011;
            end
            //jump opcode
            8'b0000_0110: begin
                WRITEENABLE = 1'b0;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b1;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b000;
            end
            //branch if equal opcode
            8'b0000_0111: begin
                WRITEENABLE = 1'b0;
                SUBSTRACT_SELECT = 1'b1;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b1;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b001;
            end

            //lwd 
            8'b0000_1000: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                JUMP = 1'b0;
                READ = 1'b1;
                WRITE = 1'b0;
                ALUOP = 3'b000;
            end

            //lwi 
            8'b0000_1001: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b1;
                BRANCHEQ = 1'b0;
                JUMP = 1'b0;
                READ = 1'b1;
                WRITE = 1'b0;
                ALUOP = 3'b000;
            end

            //swd
            8'b0000_1010: begin
                WRITEENABLE = 1'b0;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b1;
                ALUOP = 3'b000;
            end

            //swi
            8'b0000_1011: begin
                WRITEENABLE = 1'b0;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b1;
                BRANCHEQ = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b1;
                ALUOP = 3'b000;
            end



            //branch if not equal opcode
            8'b0000_1100: begin
                WRITEENABLE = 1'b0;
                SUBSTRACT_SELECT = 1'b1;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b1;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b001;
            end
            //srl opcode
            8'b0000_1101: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b1;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b100;
            end
            //sra opcode
            8'b0000_1110: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b1;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b01;
                ALUOP = 3'b100;
            end
            //ror opcode
            8'b0000_1111: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b1;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b10;
                ALUOP = 3'b100;
            end
            //sll opcode
            8'b0001_0000: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b1;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b11;
                ALUOP = 3'b100;
            end
            //mult opcode
            8'b0001_0001: begin
                WRITEENABLE = 1'b1;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                SHIFTOP = 2'b00;
                ALUOP = 3'b101;
            end
            //for undefined opcodes
            default : begin
                WRITEENABLE = 1'b0;
                SUBSTRACT_SELECT = 1'b0;
                IMMEDIATE_SELECT = 1'b0;
                BRANCHEQ = 1'b0;
                BRANCHNE = 1'b0;
                JUMP = 1'b0;
                READ = 1'b0;
                WRITE = 1'b0;
                ALUOP = 3'b1xx;
            end
        endcase
    end

    
endmodule