`ifndef PORCESSOR_DEFINES
`define PORCESSOR_DEFINES

`define oper_type inst[31:27]
`define rd inst[26:22]
`define rs1 inst[21:17]
`define imm_mode inst[16]
`define rs2 inst[15:11]
`define isrc inst[15:0]

`define movsgpr 5'b00000
`define mov     5'b00001
`define add     5'b00010
`define sub     5'b00011
`define mul     5'b00100

`define ror     5'b00101
`define rand    5'b00110
`define rxor    5'b00111
`define rxnor   5'b01000
`define rnand   5'b01001
`define rnor    5'b01010
`define rnot    5'b01011

`define store_reg 5'b01101
`define store_din 5'b01110
`define send_dout 5'b01111
`define send_reg 5'b10001

`define jump 5'b10010
`define jump_carry 5'b10011
`define jump_noncarry 5'b10100
`define jump_sign 5'b10101
`define jump_nonsign 5'b10110
`define jump_zero 5'b10111
`define jump_nonzero 5'b11000
`define jump_overflow 5'b11001
`define jump_nonoverflow 5'b11010

`define halt 5'b11011


`endif