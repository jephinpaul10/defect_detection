`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2024 10:46:07
// Design Name: 
// Module Name: mac_unit
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


module mac_unit (
    input signed [7:0] a,         // Input A (data or previous layer output)
    input signed [7:0] b,         // Input B (weight)
    input signed [15:0] accum_in, // Accumulated input
    output signed [15:0] accum_out // Accumulated output
);
    assign accum_out = accum_in + a * b;
endmodule
