/****************************************
other_components module
Name    : Perera G K B H
ENo     : E/16/276

This module contains,
    mux_2x1_8bit module
    mux_2x1_32bit module
    mux_2x1_1bit module
    module to get the 2s complement
    register of 32 bits
    adder 32 bit module with a delay of #1
    adder 32 bit module with a delay of #2
    adder 8 bit module
        
*****************************************/
`timescale 1s/100ms

//mux_2x1_8bit module
module mux_2x1_8bit(IN0, IN1, OUT, SELECT);

    //declare the ports
    input [7:0] IN0, IN1;
    input SELECT;
    output reg [7:0] OUT;
    
    //connect the relevent input to the output depending depending on the select
    always @ (IN0, IN1, SELECT) begin
        if (SELECT)
            OUT = IN1;
        else 
            OUT = IN0;
    end
endmodule

//mux_2x1_1bit module
module mux_2x1_1bit(IN0, IN1, OUT, SELECT);
    //declare the ports
    input IN0, IN1;
    input SELECT;
    output reg OUT;
    
    //connect the relevent input to the output depending depending on the select
    always @ (IN0, IN1, SELECT) begin
        if (SELECT)
            OUT = IN1;
        else 
            OUT = IN0;
    end
endmodule

//mux_2x1_32bit module
module mux_2x1_32bit(IN0, IN1, OUT, SELECT);

    //declare the ports
    input [31:0] IN0, IN1;
    input SELECT;
    output reg [31:0] OUT;
    
    //connect the relevent input to the output depending depending on the select
    always @ (IN0, IN1, SELECT) begin
        if (SELECT)
            OUT = IN1;
        else 
            OUT = IN0;
    end
endmodule

//module to get the 2s complement
module complement2s(IN, OUT);

    //declare the ports
    input [7:0] IN;
    output [7:0] OUT;

    //invert the input and add 1 and send to output
    assign #1 OUT = ~IN + 8'sb0000_0001;

endmodule

//register of 32 bits with asynchronous reset
module register_32bit (IN, OUT, RESET, CLK, BUSYWAIT);

    //declare the ports
    input [31:0] IN;
    input RESET, CLK, BUSYWAIT;
    output reg [31:0] OUT;

    //reset the register to -4 whenever the reset signal changes from low to high
    //resetting has a #1 delay
    always @ (RESET) begin
        if (RESET) #1 OUT = -32'd4;
    end

    //write the input value to the register when the reset is low and when the clock is at a positive edge and busywait is low 
    //writting to the register has a #1 delay
    always @ (posedge CLK) begin
        #1
        if (!RESET & !BUSYWAIT)  OUT = IN;
    end

endmodule

//adder 32 bit with delay #1
module adder_32bit_delay1(IN1, IN2, OUT);

    //declare ports
    input [31:0] IN1, IN2;
    output [31:0] OUT;

    //add the input values and assign to output
    //adding has a #1 delay
    assign #1 OUT = IN1 + IN2;

endmodule

//adder 32 bit with delay #2
module adder_32bit_delay2(IN1, IN2, OUT);

    //declare ports
    input [31:0] IN1, IN2;
    output [31:0] OUT;

    //add the input values and assign to output
    //adding has a #2 delay
    assign #2 OUT = IN1 + IN2;

endmodule

//adder 8 bit
module adder_8bit(IN1, IN2, OUT);

    //declare ports
    input [7:0] IN1, IN2;
    output [7:0] OUT;

    //add the input values and assign to output
    assign OUT = IN1 + IN2;

endmodule
