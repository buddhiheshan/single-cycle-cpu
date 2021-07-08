/****************************************

data_cache module
Name    : Perera G K B H
ENo     : E/16/276

*****************************************/

`timescale 1s/100ms

module data_cache(
    CLK,
    RESET,

    BUSYWAIT,
    READ,
    WRITE,
    WRITEDATA,
    READDATA,
    ADDRESS,
    
    MEM_BUSYWAIT,
    MEM_READ,
    MEM_WRITE,
    MEM_READDATA,
    MEM_WRITEDATA,
    MEM_ADDRESS
);

//port declaration
input READ, WRITE, CLK, RESET, MEM_BUSYWAIT;
input [7:0] WRITEDATA, ADDRESS;
input [31:0] MEM_READDATA;

output reg [5:0] MEM_ADDRESS;
output reg [31:0] MEM_WRITEDATA;
output [7:0] READDATA;
output reg BUSYWAIT, MEM_READ, MEM_WRITE;

//create reg arrays in the cache
reg [31:0] DATA [7:0];
reg [2:0] TAG [7:0];
reg DIRTY [7:0];
reg VALID [7:0];

//set busywait if read or write signal is received
always @ (READ, WRITE)
begin
    if (READ || WRITE) 
        BUSYWAIT = 1;
    else
        BUSYWAIT = 0;
end

//wires to store the extracted values depending on the index part of the address
wire VALID_OUT, DIRTY_OUT;
wire [31:0] DATA_OUT;
wire [2:0] TAG_OUT;

// //Obtaining the stored values from the register array depending on the index
assign #1 DATA_OUT = DATA[ADDRESS[4:2]];
assign #1 VALID_OUT = VALID[ADDRESS[4:2]];
assign #1 DIRTY_OUT = DIRTY[ADDRESS[4:2]];
assign #1 TAG_OUT = TAG[ADDRESS[4:2]];

//tag compare and determining the hit status
wire TAG_STATUS, HIT;
assign #0.9 TAG_STATUS = (TAG_OUT == ADDRESS[7:5]) ? 1 : 0;
assign HIT = VALID_OUT && TAG_STATUS;

//clear busywait at positive clock edge and when there is a hit
always @ (posedge CLK)
begin
    if (HIT) BUSYWAIT = 0;
end

//select data from offsets
assign #1 READDATA =    ((ADDRESS[1:0] == 2'b01) && READ) ? DATA_OUT[15:8] : 
                        ((ADDRESS[1:0] == 2'b10) && READ) ? DATA_OUT[23:16] :
                        ((ADDRESS[1:0] == 2'b11) && READ) ? DATA_OUT[31:24] : DATA_OUT[7:0];

//write data to cache
always @ (posedge CLK)
begin
    if (HIT && WRITE)
    begin
        #1
        DIRTY[ADDRESS[4:2]] = 1;
        case (ADDRESS[1:0])
            2'b01 :
                DATA[ADDRESS[4:2]][15:8] = WRITEDATA;
            2'b10 :
                DATA[ADDRESS[4:2]][23:16] = WRITEDATA;
            2'b11 :
                DATA[ADDRESS[4:2]][31:24] = WRITEDATA;
            default :
                DATA[ADDRESS[4:2]][7:0] = WRITEDATA;
        endcase
    end
end

/* Cache Controller FSM Start */
parameter IDLE = 2'b00, READ_MEM = 2'b10, WRITE_MEM = 2'b01, UPDATE_CACHE = 2'b11;
reg [1:0] STATE, NEXT_STATE;

// combinational next state logic
always @(*)
begin
    case (STATE)
        IDLE:
            if ((READ || WRITE) && !DIRTY_OUT && !HIT)  
               NEXT_STATE = READ_MEM;
            else if ((READ || WRITE) && DIRTY_OUT && !HIT)
                NEXT_STATE = WRITE_MEM;
            else
                NEXT_STATE = IDLE;
            
        READ_MEM:
            if (!MEM_BUSYWAIT)
                NEXT_STATE = UPDATE_CACHE;
            else    
                NEXT_STATE = READ_MEM;
        
        WRITE_MEM:
            if (!MEM_BUSYWAIT)
                NEXT_STATE = READ_MEM;
            else
                NEXT_STATE = WRITE_MEM;

        UPDATE_CACHE:
            NEXT_STATE = IDLE;
            
    endcase
end

// combinational output logic
always @(STATE)
begin
    case(STATE)
        IDLE:
        begin
            MEM_READ = 0;
            MEM_WRITE = 0;
            MEM_ADDRESS = 8'dx;
            MEM_WRITEDATA = 32'dx;
        end
         
        READ_MEM: 
        begin
            MEM_READ = 1;
            MEM_WRITE = 0;
            MEM_ADDRESS = {ADDRESS[7:2]};
            MEM_WRITEDATA = 32'dx;
            // BUSYWAIT = 1;
        end

        WRITE_MEM: 
        begin
            MEM_READ = 0;
            MEM_WRITE = 1;
            MEM_ADDRESS = {TAG_OUT, ADDRESS[4:2]};
            MEM_WRITEDATA = DATA_OUT;
        end

        UPDATE_CACHE:
        begin
            #1
            DATA[ADDRESS[4:2]] = MEM_READDATA;
            DIRTY[ADDRESS[4:2]] = 0;
            VALID[ADDRESS[4:2]] = 1;
            TAG[ADDRESS[4:2]] = ADDRESS[7:5];
        end
            
    endcase
end

// sequential logic for state transitioning 
always @ (posedge CLK, RESET)
begin
    if(RESET)
        STATE = IDLE;
    else
        STATE = NEXT_STATE;
end


//reset the cache memory when the reset signal is high
integer i;

always @ (RESET)
begin
    if(RESET)
    begin
        for ( i = 0; i < 8; i = i + 1)
        begin
            VALID[i] = 0;
            DIRTY[i] = 0;
            TAG[i] = 3'bx;
            BUSYWAIT = 0;
            DATA[i] = 32'dx;
        end
    end
end
    
endmodule