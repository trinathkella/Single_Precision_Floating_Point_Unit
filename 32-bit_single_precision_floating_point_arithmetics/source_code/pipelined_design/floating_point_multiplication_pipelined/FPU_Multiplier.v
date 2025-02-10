`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2025 12:37:04 PM
// Design Name: 
// Module Name: mutliplication
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


module multiplication
#(parameter D_WIDTH = 32,
  parameter M_WIDTH = 23,
  parameter E_WIDTH = 8,
  parameter M       = 48
 )
 (
    input                 clk_in,
    input                 reset_n,
    input                 fsm_enable,
    input  [D_WIDTH-1 : 0]floating1_in,
    input  [D_WIDTH-1 : 0]floating2_in,
    output reg [D_WIDTH-1 : 0]floating_multiplication_out 
 );
    //Partitioning bits for sign,exponent,mantissa;
    wire                sign1,sign2;
    wire [E_WIDTH-1 : 0]exp1,exp2;
    wire [M_WIDTH-1 : 0]m1,m2;
    
    //WIRES_FOR_PIPELINED_ENABLING_SIGNALS
    wire                enable_stage1;
    wire                enable_stage2;
    wire                enable_stage3;
    //Final sign, exponent and mantissa
    //wire [E_WIDTH-1 : 0]output_exponent;
    //wire [M_WIDTH-1 : 0]output_mantissa;
    wire                output_sign;
    
    reg [D_WIDTH-1 : 0] floating1_in_proc;
    reg [D_WIDTH-1 : 0] floating2_in_proc;
    
    always@(posedge clk_in)begin : REGISTERED_INPUTS
        if(~reset_n)begin
            floating1_in_proc <= 32'd0;
            floating2_in_proc <= 32'd0;
        end else if (enable_stage1)begin
            floating1_in_proc <= floating1_in;
            floating2_in_proc <= floating2_in;
        end
    end
    
    //input Numbers
    assign sign1 = floating1_in_proc[D_WIDTH-1]; //[31]
    assign exp1  = floating1_in_proc[D_WIDTH-2 -: E_WIDTH]; //[30:23]
    assign m1    = floating1_in_proc[M_WIDTH-1 -: M_WIDTH]; //[22:0]
    
    assign sign2 = floating2_in_proc[D_WIDTH-1];
    assign exp2  = floating2_in_proc[D_WIDTH-2 -: E_WIDTH];
    assign m2    = floating2_in_proc[M_WIDTH-1 -: M_WIDTH];
    
    //Intermediate outputs
    wire [E_WIDTH : 0]exp_out;
    wire [E_WIDTH : 0]unbiased_exp_out;
    wire [M - 1   : 0]multiply_out;
    
    //Input for passing to the normalizer
    wire [E_WIDTH : 0]exp_to_the_normalizer;
    wire [M - 1   : 0]mantissa;
    
    //Outputs from the normalizer
    wire [M_WIDTH - 1 : 0] normalized_mantissa;
    wire [E_WIDTH - 1 : 0] normalized_exponent;
    
    FSM flow_control
    (
        .clk_in(clk_in),
        .reset_n(reset_n),
        .fsm_enable(fsm_enable),
        .enable_stage1(enable_stage1),
        .enable_stage2(enable_stage2),
        .enable_stage3(enable_stage3)
    );
    
    // Exponent Addition
    nbit_adder n1(.A(exp1), .B(exp2), .Cin(1'b0), .sum(exp_out));
    
    //Unbiasing the exp_out with 127
    assign unbiased_exp_out = exp_out + (8'b1000_0000 + 1);
    
    //Multiplying the mantissas
    assign multiply_out = {1'b1 , m1} * {1'b1, m2};
    
    //Inputs to the Normalizer
    assign exp_to_the_normalizer = unbiased_exp_out;
    assign mantissa              = multiply_out;
    
    reg [M - 1   : 0] mantissa_proc;
    reg [E_WIDTH : 0] exp_to_the_normalizer_proc;
    
    always@(posedge clk_in)begin : PIPELINED 
        if(~reset_n)begin
            mantissa_proc <= 0;
            exp_to_the_normalizer_proc <= 0;
        end else if(enable_stage2) begin
            mantissa_proc <= mantissa;
            exp_to_the_normalizer_proc <= exp_to_the_normalizer;
        end    
    end
    
    //Normalizer
    Normalizer n(.mantissa_from_multiplier(mantissa_proc),.exponent_from_subtractor(exp_to_the_normalizer_proc), .normalized_mantissa(normalized_mantissa), .normalized_exponent(normalized_exponent));

    //assign output_mantissa = normalized_mantissa;
    //assign output_exponent = normalized_exponent;
    assign output_sign     = sign1 ^ sign2;
    wire [D_WIDTH-1 : 0] floating_multiplication_out_wire;
    //Final Result
    assign floating_multiplication_out_wire = {output_sign, normalized_exponent, normalized_mantissa}; 
    
    always@(posedge clk_in)begin
        if(~reset_n)begin
            floating_multiplication_out <= 0;
        end else if(enable_stage3)begin
            floating_multiplication_out <= floating_multiplication_out_wire;
        end
    end 
    
endmodule
