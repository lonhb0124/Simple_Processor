`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2024 03:42:09 PM
// Design Name: 
// Module Name: proc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module proc_tb(

    );

logic clk = 0, reset = 0;
logic [15:0] din = 0;
logic [15:0] dout;
integer i = 0;

processor dut (.clk(clk), .reset(reset), .din(din), .dout(dout));

always #5 clk = ~clk;

initial begin
    reset = 1;
    repeat(5) @(posedge clk);
    reset = 0;
    din = 3;
    #800;
    $stop;
end

endmodule
/*    
processor dut ();

initial begin
for ( i = 0; i < 32; i = i + 1)
    begin
        dut.processor_reg[i] = 2;
    end
end

initial begin

$display("============================================================");
dut.inst = 0;
dut.`imm_mode = 1;
dut.`oper_type = 2;
dut.`rs1 = 2;
dut.`rd = 0;
dut.`isrc = 4;
#10;
$display("OP:ADI rs1:%0d, imm_data:%0d,  rd:%0d", dut.processor_reg[2], dut.`isrc, dut.processor_reg[0]);

$display("============================================================");
dut.inst = 0;
dut.`imm_mode = 0;
dut.`oper_type = 2;
dut.`rs1 = 4;
dut.`rs2 = 5;
dut.`rd = 0;
#10;
$display("OP:ADD rs1:%0d, rs2:%0d,  rd:%0d", dut.processor_reg[4], dut.processor_reg[5], dut.processor_reg[0]);

$display("============================================================");
dut.inst = 0;
dut.`imm_mode = 1;
dut.`oper_type = 1;
dut.`rd = 4;
dut.`isrc = 55;
#10;
$display("OP:MOVI rd:%0d, imm_data:%0d", dut.processor_reg[4], dut.`isrc);

$display("============================================================");
dut.inst = 0;
dut.`imm_mode = 0;
dut.`oper_type = 1;
dut.`rd = 4;
dut.`rs1 = 7;
#10;
$display("OP:MOV rd:%0d, rs1:%0d", dut.processor_reg[4], dut.processor_reg[7]);
$display("============================================================");

dut.inst = 0;
dut.`imm_mode = 0;
dut.`oper_type = 4;
dut.`rd = 2;
dut.`rs1 = 0;
dut.`rs2 = 1;
#10;
dut.inst = 0;
dut.`imm_mode = 0;
dut.`oper_type = 0;
dut.`rd = 3;
#10;
$display("OP:MUL rd2:%0d, rd3:%0d, rs1:%0d, rs2:%0d", dut.processor_reg[2], dut.processor_reg[3], dut.processor_reg[0], dut.processor_reg[1]);
$display("============================================================");

dut.inst = 0;
dut.`imm_mode = 1;
dut.`oper_type = 6;
dut.`rd = 4;
dut.`rs1 = 7;
dut.`isrc = 56;
#10;
$display("OP:ANDI rd:%8b, rs1:%8b, imm_data:%8b", dut.processor_reg[4], dut.processor_reg[7], dut.`isrc);
$display("============================================================");

dut.inst = 0;
dut.`imm_mode = 1;
dut.`oper_type = 7;
dut.`rd = 4;
dut.`rs1 = 7;
dut.`isrc = 56;
#10;
$display("OP:XORI rd:%8b, rs1:%8b, imm_data:%8b", dut.processor_reg[4], dut.processor_reg[7], dut.`isrc);
$display("============================================================");

dut.inst = 0;
dut.`imm_mode = 0;
dut.`oper_type = 5;
dut.`rd = 0;
dut.`rs1 = 4;
dut.`rs2 = 16;
#10;
$display("OP:OR rd:%8b, rs1:%8b, rs2:%8b", dut.processor_reg[0], dut.processor_reg[4], dut.processor_reg[16]);
$display("============================================================");

dut.inst = 0;
dut.`imm_mode = 0;
dut.`oper_type = 10;
dut.`rd = 0;
dut.`rs1 = 4;
dut.`rs2 = 16;
#10;
$display("OP:NOR rd:%16b, rs1:%8b, rs2:%8b", dut.processor_reg[0], dut.processor_reg[4], dut.processor_reg[16]);
$display("============================================================");

dut.inst = 0;
dut.`imm_mode = 0;
dut.`oper_type = 11;
dut.`rd = 0;
dut.`rs1 = 6;
#10;
$display("OP:XORI rd:%16b, rs1:%8b", dut.processor_reg[0], dut.processor_reg[6]);
$display("============================================================");

dut.inst = 0;
dut.processor_reg[0] = 0;
dut.processor_reg[1] = 0;
dut.`imm_mode = 0;
dut.`oper_type = 2;
dut.`rd = 2;
dut.`rs1 = 0;
dut.`rs2 = 1;
#10;
$display("OP:Zero rd:%0d, rs1:%0d rs2:%0d", dut.processor_reg[2], dut.processor_reg[0], dut.processor_reg[1]);
$display("============================================================");

dut.inst = 0;
dut.processor_reg[0] = 16'h8000;
dut.processor_reg[1] = 0;
dut.`imm_mode = 0;
dut.`oper_type = 2;
dut.`rd = 2;
dut.`rs1 = 0;
dut.`rs2 = 1;
#10;
$display("OP:Sign rd:%0d, rs1:%0d rs2:%0d", dut.processor_reg[2], dut.processor_reg[0], dut.processor_reg[1]);
$display("============================================================");

dut.inst = 0;
dut.processor_reg[0] = 16'h8000;
dut.processor_reg[1] = 16'h8002;
dut.`imm_mode = 0;
dut.`oper_type = 2;
dut.`rd = 2;
dut.`rs1 = 0;
dut.`rs2 = 1;
#10;
$display("OP:Carry & Overflow rd:%0d, rs1:%0d rs2:%0d", dut.processor_reg[2], dut.processor_reg[0], dut.processor_reg[1]);
$display("============================================================");

end
    
endmodule
*/