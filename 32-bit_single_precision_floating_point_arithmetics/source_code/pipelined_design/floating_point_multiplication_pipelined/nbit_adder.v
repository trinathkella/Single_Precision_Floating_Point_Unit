`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2025 11:48:00 PM
// Design Name: 
// Module Name: nbit_adder
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


module nbit_adder #(parameter N = 8)(
    input [N-1 : 0]A, B,
    input Cin,
    output [N : 0]sum
    );
    wire [N-1 : 0]carry;
    
    full_adder f1(A[0], B[0], Cin, sum[0], carry[0]);
    
    generate
        genvar i;
        for(i = 1; i < N; i = i+1)
        begin
            full_adder fo(A[i], B[i], carry[i-1], sum[i], carry[i]);
        end        
    endgenerate
    
    assign sum[N] = carry[N-1];
    
endmodule
