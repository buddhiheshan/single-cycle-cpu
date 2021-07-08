/****************************************

mulipilier module
Name    : Perera G K B H
ENo     : E/16/276

*****************************************/
`timescale 1s/100ms

//unsigned multiplier
//since the result is of 8 bits, overflow is neglected
//maximum value of the product is 255

module multiplier(DATA1, DATA2, PRODUCT_DELAYED);
    //declare ports
    input [7:0] DATA1, DATA2;
    output [7:0] PRODUCT_DELAYED;
    wire [7:0] PRODUCT;

    //add a delay of #3
    assign #3 PRODUCT_DELAYED = PRODUCT;

    reg [7:0] zeros = 8'b00000000;


    wire [7:0] mux1_in,mux2_in,mux3_in,mux4_in,mux5_in,mux6_in,mux7_in,mux8_in;

    //shift the multiplicand by rerouting
    assign mux1_in = DATA1;
    assign mux2_in = {DATA1[6:0],1'd0};
    assign mux3_in = {DATA1[5:0],2'd0};
    assign mux4_in = {DATA1[4:0],3'd0};
    assign mux5_in = {DATA1[3:0],4'd0};
    assign mux6_in = {DATA1[2:0],5'd0};
    assign mux7_in = {DATA1[1:0],6'd0};
    assign mux8_in = {DATA1[0],7'd0};

    wire [7:0] adder1a_in1,adder1a_in2,adder1b_in1,adder1b_in2,adder1c_in1,adder1c_in2,adder1d_in1,adder1d_in2;
    wire [7:0] adder2a_in1,adder2a_in2,adder2b_in1,adder2b_in2,adder3_in1,adder3_in2;

    //calculate the partial products
    //each bit if the mutiplier value is a control signal to a mux.
    //depending in the multiplier's nth bit muxes will forward 00000000 or shifted values
    mux_2x1_8bit mux1(zeros, mux1_in, adder1a_in1,DATA2[0]);
    mux_2x1_8bit mux2(zeros, mux2_in, adder1a_in2,DATA2[1]);
    mux_2x1_8bit mux3(zeros, mux3_in, adder1b_in1,DATA2[2]);
    mux_2x1_8bit mux4(zeros, mux4_in, adder1b_in2,DATA2[3]);
    mux_2x1_8bit mux5(zeros, mux5_in, adder1c_in1,DATA2[4]);
    mux_2x1_8bit mux6(zeros, mux6_in, adder1c_in2,DATA2[5]);
    mux_2x1_8bit mux7(zeros, mux7_in, adder1d_in1,DATA2[6]);
    mux_2x1_8bit mux8(zeros, mux8_in, adder1d_in2,DATA2[7]);

    //level 1 adders
    //add the patial products, 8 rows and 4 adders add parallaly
    adder_8bit adder1a(adder1a_in1,adder1a_in2,adder2a_in1);
    adder_8bit adder1b(adder1b_in1,adder1b_in2,adder2a_in2);
    adder_8bit adder1c(adder1c_in1,adder1c_in2,adder2b_in1);
    adder_8bit adder1d(adder1d_in1,adder1d_in2,adder2b_in2);

    //level 2 adders
    //add the values from 4 adders, 4 values 2 adders
    adder_8bit adder2a(adder2a_in1,adder2a_in2,adder3_in1);
    adder_8bit adder2b(adder2b_in1,adder2b_in2,adder3_in2);

    //level 3 adders
    //add the values from 2 adders
    //this will give the product
    adder_8bit adder3(adder3_in1,adder3_in2,PRODUCT);

endmodule