/****************************************

cpu_tb module
Name    : Perera G K B H
ENo     : E/16/276

*****************************************/

//include the necessary files
`include "cpu.v"
`include "data_memory.v"
`include "data_cache.v"
`include "instruction_memory.v"
`include "instruction_cache.v"
`timescale 1s/100ms


module cpu_tb();

    //instruction memory 8x1024 (256 instructions)
    reg [7:0] INSTRUCTION_MEM [0:1023];

    wire [7:0] DATA_ADDRESS, WRITEDATA, DATA_READDATA;
    wire [5:0] DATAMEM_ADDRESS;
    wire [31:0] MEM_WRITEDATA, DATAMEM_READDATA;
    wire  READ, WRITE, DATA_BUSYWAIT, DATAMEM_READ, MEM_WRITE, DATAMEM_BUSYWAIT, INST_BUSYWAIT,INSTMEM_BUSYWAIT, INSTMEM_READ, BUSYWAIT;
    wire [9:0] INST_ADDRESS;
    wire [5:0] INSTMEM_ADDRESS;
    wire [31:0] INST_READDATA;
    wire [127:0] INSTMEM_READDATA;
    reg CLK, RESET;

    //for the loop to dump register array
    integer i;

    //busywait signals from instruction cache and data cache is OR and sent to the busywait of the cpu
    assign BUSYWAIT = (DATA_BUSYWAIT | INST_BUSYWAIT);

    //cpu, caches and memories
    cpu mycpu(INST_ADDRESS, INST_READDATA, CLK, RESET, DATA_ADDRESS, WRITEDATA, READ, WRITE, BUSYWAIT, DATA_READDATA);

    data_cache mydatacache(CLK, RESET, DATA_BUSYWAIT, READ, WRITE, WRITEDATA, DATA_READDATA, DATA_ADDRESS, DATAMEM_BUSYWAIT, DATAMEM_READ, MEM_WRITE, DATAMEM_READDATA, MEM_WRITEDATA, DATAMEM_ADDRESS);

    data_memory mydatamemory(CLK, RESET, DATAMEM_READ, MEM_WRITE, DATAMEM_ADDRESS, MEM_WRITEDATA, DATAMEM_READDATA, DATAMEM_BUSYWAIT);

    instruction_cache myinstcache(CLK, RESET, INST_ADDRESS, INST_READDATA, INST_BUSYWAIT, INSTMEM_ADDRESS, INSTMEM_READ, INSTMEM_READDATA, INSTMEM_BUSYWAIT);

    instruction_memory myinstmemory(CLK, INSTMEM_READ, INSTMEM_ADDRESS, INSTMEM_READDATA, INSTMEM_BUSYWAIT);



    initial begin
        
        ///monitor using gtkwave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);

        //monitor the values in the register file
        //uncomment this to dump the values stored in the register file, data memory and data cache.
        // For debugging.
        // THIS WILL GENERATE A WARNING.
        // for (i = 0; i < 8; i = i + 1) $dumpvars(0, mycpu.myregister.REGISTER[i]);
        // for (i = 0; i < 8; i = i + 1) $dumpvars(0, mydatacache.DATA[i]);
        // for (i = 0; i < 8; i = i + 1) $dumpvars(0, mydatacache.VALID[i]);
        // for (i = 0; i < 8; i = i + 1) $dumpvars(0, mydatacache.TAG[i]);
        // for (i = 0; i < 8; i = i + 1) $dumpvars(0, mydatacache.DIRTY[i]);
        // for (i = 0; i < 5; i = i + 1) $dumpvars(0, mydatamemory.memory_array[i]);
        // for (i = 32; i < 37; i = i + 1) $dumpvars(0, mydatamemory.memory_array[i]);
        // for (i = 0; i < 8; i = i + 1) $dumpvars(0, myinstcache.DATA[i]);
        // for (i = 0; i < 8; i = i + 1) $dumpvars(0, myinstcache.VALID[i]);
        // for (i = 0; i < 8; i = i + 1) $dumpvars(0, myinstcache.TAG[i]);

        //initiate the clock
        CLK = 1'b1;

        RESET = 1'b0;

        #1
        RESET = 1'b1;

        #5
        RESET = 1'b0;

        #1600

        $finish; // finish the program
    end

    //clock signal generation
    always
        #4 CLK = ~CLK;

endmodule