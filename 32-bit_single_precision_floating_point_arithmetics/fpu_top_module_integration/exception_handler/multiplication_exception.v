`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2025 09:32:49 PM
// Design Name: 
// Module Name: multiplication_exception
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


module multiplication_exception #(parameter DATA_WIDTH = 32
                          )
(
    input  [DATA_WIDTH - 1 : 0] float_num1,
    input  [DATA_WIDTH - 1 : 0] float_num2,
    output reg                      sel,
    output reg [DATA_WIDTH - 1 : 0] out
    );
    
    always @(*)
    begin
        if(float_num1 == 32'h0000_0000 || float_num2 == 32'h0000_0000) begin   
            out = 32'h0000_0000;
            sel = 1'b0;
        end
        
        else if(float_num1 == 32'h7F80_0000 || float_num2 == 32'h7F80_0000) begin   
            out = 32'h7F80_0000;    // any_number * infinity = infinity
            sel = 1'b0;
        end 
        
        else begin   
            out = 32'h0000_0000;
            sel = 1'b1;
        end 
    
    end
endmodule
