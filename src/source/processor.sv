`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2024 02:19:38 PM
// Design Name: 
// Module Name: processor
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
`include "processorDefines.vh"

module processor(
    input clk, reset,
    input  [15:0] din, 
    output logic [15:0] dout
    ); 
    
localparam STATE_IDLE = 3'd0;
localparam STATE_FETCH_INST = 3'd1;
localparam STATE_DEC_EXEC_INST = 3'd2;
localparam STATE_NEXT_INST = 3'd3;   
localparam STATE_SENSE_HALT = 3'd4;
localparam STATE_DELAY_NEXT_INST = 3'd5;    
logic [2:0] state_reg, state_next;   
    
 
logic [31:0] inst;
logic [15:0] processor_reg [31:0] ;
logic [15:0] special_reg;
logic [31:0] mul_reg;
logic sign, zero, overflow, carry;
logic [16:0] temp_sum;

logic wea = 0;
logic [2:0] count = 0;
logic [10:0] addr;
logic [31:0] inst_mem [15:0];
logic [15:0] data_mem [15:0];
logic jump_flag = 0;
logic stop = 0;
integer PC = 0;


initial begin
$readmemb("inst_data_2.mem", inst_mem);
//$readmemh("data.mem", data_mem);
end

always @(posedge clk)
begin
    if (reset) begin
        state_reg <= STATE_IDLE;
    end
    else begin
        state_reg <= state_next;
        if (state_reg == STATE_DELAY_NEXT_INST) begin
            count <= count + 1;
        end
        else begin
            count <= 0;
        end
    end
end


always @(*)
begin
    case(state_reg)
        STATE_IDLE : begin
            inst = 0;
            PC = 0;
            state_next = STATE_FETCH_INST; 
        end
        
        STATE_FETCH_INST : begin
            inst = inst_mem[PC];
            state_next = STATE_DEC_EXEC_INST; 
        end
        
        STATE_DEC_EXEC_INST : begin
            decode_inst();
            decode_flag();
            state_next = STATE_DELAY_NEXT_INST;
        end
        
        STATE_DELAY_NEXT_INST : begin
            if (count < 4) begin
                state_next = STATE_DELAY_NEXT_INST;
            end
            else begin
                state_next = STATE_NEXT_INST;
            end   
        end
        
        STATE_NEXT_INST : begin
            if (jump_flag) begin
                PC = `isrc;
            end
            else begin
                PC = PC + 1;
            end
            state_next = STATE_SENSE_HALT;
        end
        
        STATE_SENSE_HALT : begin
            if (!stop) begin
                state_next = STATE_FETCH_INST;
            end
            else if (reset) begin
                state_next = STATE_IDLE;
            end
            else begin
                state_next = STATE_SENSE_HALT;
            end
        end
        
        default : begin 
            state_next = STATE_IDLE; 
        end
        
        
    endcase
end

/*
always @(posedge clk)
begin
    if (reset) begin
        count <= 0;
        PC <= 0;
    end
    else begin
        if (count < 4) begin
            count <= count + 1;
        end
        else begin
            count <= 0;
            PC <= PC + 1;
        end
    end
end

always @(*)
begin
    if (reset) begin
        inst = 0;
    end
    else begin
        inst = inst_mem[PC];
        decode_inst();
        decode_flag();
    end
end
*/

task decode_inst();
begin

jump_flag = 0;
stop = 0;

case(`oper_type)
    `movsgpr : begin
                 processor_reg[`rd] = special_reg;
               end
    
    `mov : begin
               if (`imm_mode) begin
                   processor_reg[`rd] = `isrc;
               end
               else begin 
                   processor_reg[`rd] = processor_reg[`rs1];
               end    
           end
    
    `add :  begin
               if (`imm_mode) begin
                   processor_reg[`rd] = processor_reg[`rs1] + `isrc;
               end
               else begin 
                   processor_reg[`rd] = processor_reg[`rs1] + processor_reg[`rs2];
               end
            end
   
    `sub : begin
              if (`imm_mode) begin
                   processor_reg[`rd] = processor_reg[`rs1] - `isrc;
              end
              else begin 
                   processor_reg[`rd] = processor_reg[`rs1] - processor_reg[`rs2];
              end
           end
    
    `mul : begin
              if (`imm_mode) begin
                   mul_reg = processor_reg[`rs1] * `isrc;
              end
              else begin 
                   mul_reg = processor_reg[`rs1] * processor_reg[`rs2];
              end
              processor_reg[`rd] = mul_reg[15:0];
              special_reg =  mul_reg[31:16];
           end
           
    `ror : begin
              if (`imm_mode) begin
                   processor_reg[`rd] = processor_reg[`rs1] | `isrc;
              end
              else begin 
                   processor_reg[`rd] = processor_reg[`rs1] | processor_reg[`rs2];
              end
           end
           
    `rand : begin
              if (`imm_mode) begin
                   processor_reg[`rd] = processor_reg[`rs1] & `isrc;
              end
              else begin 
                   processor_reg[`rd] = processor_reg[`rs1] & processor_reg[`rs2];
              end
           end   
               
    `rxor : begin
              if (`imm_mode) begin
                   processor_reg[`rd] = processor_reg[`rs1] ^ `isrc;
              end
              else begin 
                   processor_reg[`rd] = processor_reg[`rs1] ^ processor_reg[`rs2];
              end
           end       

    `rxnor : begin
              if (`imm_mode) begin
                   processor_reg[`rd] = processor_reg[`rs1] ~^ `isrc;
              end
              else begin 
                   processor_reg[`rd] = processor_reg[`rs1] ~^ processor_reg[`rs2];
              end
           end   
           
    `rnand : begin
              if (`imm_mode) begin
                   processor_reg[`rd] = ~(processor_reg[`rs1] & `isrc);
              end
              else begin 
                   processor_reg[`rd] = ~(processor_reg[`rs1] & processor_reg[`rs2]);
              end
           end            

    `rnor : begin
              if (`imm_mode) begin
                   processor_reg[`rd] = ~(processor_reg[`rs1] | `isrc);
              end
              else begin 
                   processor_reg[`rd] = ~(processor_reg[`rs1] | processor_reg[`rs2]);
              end
           end 
           
    `store_reg : begin
               data_mem[`isrc] = processor_reg[`rs1];
           end
           
    `store_din : begin
               data_mem[`isrc] = din;
           end     

    `send_dout : begin
               dout = data_mem[`isrc];
           end

    `send_reg : begin
               processor_reg[`rd] = data_mem[`isrc];
           end

    `jump : begin
               jump_flag = 1;
           end

    `jump_carry : begin
                if (carry) begin
                    jump_flag = 1;
                end
                else begin
                    jump_flag = 0;
                end
           end    

    `jump_noncarry : begin
                if (!carry) begin
                    jump_flag = 1;
                end
                else begin
                    jump_flag = 0;
                end
           end    
           
    `jump_sign : begin
                if (sign) begin
                    jump_flag = 1;
                end
                else begin
                    jump_flag = 0;
                end
           end               

    `jump_nonsign : begin
                if (!sign) begin
                    jump_flag = 1;
                end
                else begin
                    jump_flag = 0;
                end
           end  

    `jump_zero : begin
                if (zero) begin
                    jump_flag = 1;
                end
                else begin
                    jump_flag = 0;
                end
           end  

    `jump_nonzero : begin
                if (!zero) begin
                    jump_flag = 1;
                end
                else begin
                    jump_flag = 0;
                end
           end

    `jump_overflow : begin
                if (overflow) begin
                    jump_flag = 1;
                end
                else begin
                    jump_flag = 0;
                end
           end

    `jump_nonoverflow : begin
                if (!overflow) begin
                    jump_flag = 1;
                end
                else begin
                    jump_flag = 0;
                end
           end
           
    `halt : begin
                stop = 1;
           end           
                                                 
endcase
end
endtask

task decode_flag();
begin
    if (`oper_type == `mul) begin
        sign = special_reg[15];
        zero = ~(|(special_reg[15]) | (|processor_reg[`rd]));
    end
    else begin
        sign = processor_reg[`rd][15];
        zero = ~(|processor_reg[`rd]);
    end
    
    if (`oper_type == `add) begin
        if (`imm_mode) begin
            temp_sum = processor_reg[`rs1] + `isrc;
            carry = temp_sum[16];
            overflow = ( (~processor_reg[`rs1][15] & ~inst[15] & processor_reg[`rd][15]) | (processor_reg[`rs1][15] & inst[15] & ~processor_reg[`rd][15]));
        end 
        else begin
            temp_sum = processor_reg[`rs1] + processor_reg[`rs2];
            carry = temp_sum[16];
            overflow = ( (~processor_reg[`rs1][15] & ~processor_reg[`rs2][15] & processor_reg[`rd][15]) | (processor_reg[`rs1][15] & processor_reg[`rs2][15] & ~processor_reg[`rd][15]));
        end
    end
    else if (`oper_type == `sub) begin
        if (`imm_mode) begin
            overflow = ( (~processor_reg[`rs1][15] & inst[15] & processor_reg[`rd][15]) | (processor_reg[`rs1][15] & ~inst[15] & ~processor_reg[`rd][15]));
        end 
        else begin
            overflow = ( (~processor_reg[`rs1][15] & processor_reg[`rs2][15] & processor_reg[`rd][15]) | (processor_reg[`rs1][15] & ~processor_reg[`rs2][15] & ~processor_reg[`rd][15]));
        end
        carry = 1'b0;
    end
    else begin
        carry = 1'b0;
        overflow = 1'b0;
    end
    
end
endtask
    
endmodule