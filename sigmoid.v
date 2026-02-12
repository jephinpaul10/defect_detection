`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2024 10:04:35
// Design Name: 
// Module Name: sigmoid
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


module sigmoid_activation #(
    parameter OUTPUT_SIZE = 1,          // Single output for binary classification
    parameter DATA_WIDTH = 8     // Bit width for fixed-point representation
)(
    input signed [DATA_WIDTH-1:0] input_data,
    output reg [0:0] binary_output
);

    always @(*) begin
        // Simple threshold-based sigmoid approximation
        binary_output = (input_data > 0) ? 1'b1 : 1'b0;
    end
endmodule

