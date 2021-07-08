/****************************************
reg_file module
Name    : Perera G K B H
ENo     : E/16/276

*****************************************/
`timescale 1s/100ms

module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);

    //create the 8x8 register array
    reg [7:0] REGISTER[0:7];

    //declaring ports
    input [7:0] IN;
    input [2:0] OUT1ADDRESS, OUT2ADDRESS, INADDRESS;
    input WRITE, CLK, RESET;
    output [7:0] OUT1, OUT2;

    //variable to count the iterations in loops
    integer i;

    //reading the registers
    //this runs always when the register values changes or when the register outaddress changes
    assign #2 OUT1 = REGISTER[OUT1ADDRESS];
    assign #2 OUT2 = REGISTER[OUT2ADDRESS];

    //resetting the registers
    always @ (*) begin
        //if the reset = 1, then all the registers are set to 0
        if (RESET) begin  
            #2 for (i = 0; i < 8; i = i + 1)
                REGISTER[i] = 8'b0000_0000;
        end
    end

    //writting the values to a register
    //this runs only on positive clock edges
    always @ (posedge CLK) begin
        //if the write = 1 and reset = 0, the given register will be written with the given value
        #1
        if (WRITE & !RESET) begin
            REGISTER[INADDRESS] = IN;
        end
    end

endmodule