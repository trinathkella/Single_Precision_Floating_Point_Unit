`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2025 10:48:15 PM
// Design Name: 
// Module Name: Top_Module
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


module Top_Module #(parameter DATA_WIDTH = 32,
                    parameter OP_WIDTH   = 2)
(
    input  [DATA_WIDTH - 1 : 0] operand1_in,
    input  [DATA_WIDTH - 1 : 0] operand2_in, 
    input  [OP_WIDTH   - 1 : 0] opcode,
    
    output [DATA_WIDTH - 1 : 0] final_result 
);

    wire sel;
    wire [DATA_WIDTH - 1 : 0]exception_out;
    wire [DATA_WIDTH - 1 : 0]fpu_out;
    
    exception_handler exception_block(.float_num1(operand1_in), .float_num2(operand2_in), .opcode(opcode), .sel(sel), .exception_out(exception_out));
    
    Floating_Point_Unit fpu(.operand1_in(operand1_in), .operand2_in(operand2_in), .opcode(opcode), .fpu_out(fpu_out));
    
   assign final_result = (sel) ? fpu_out : exception_out;
     
endmodule
