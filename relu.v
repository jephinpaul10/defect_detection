`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2024 10:02:20
// Design Name: 
// Module Name: relu
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


module relu_activation #(
    parameter SIZE = 128,            // Number of elements in the input/output
    parameter DATA_WIDTH = 8         // Bit width for fixed-point representation
)(
    input signed [DATA_WIDTH*SIZE-1:0] input_data_flat,     // Flattened input data
    output reg signed [DATA_WIDTH*SIZE-1:0] output_data_flat // Flattened output data
);

    integer i;
    reg signed [DATA_WIDTH-1:0] temp_input, temp_output;

    always @(*) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            // Extract each element from flattened input
            temp_input = input_data_flat[i*DATA_WIDTH +: DATA_WIDTH];
            // Apply ReLU operation
            temp_output = (temp_input < 0) ? 0 : temp_input;
            // Store result in flattened output
            output_data_flat[i*DATA_WIDTH +: DATA_WIDTH] = temp_output;
        end
    end
endmodule


