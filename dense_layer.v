`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2024 09:59:12
// Design Name: 
// Module Name: dense_layer
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


module dense_layer #(
    parameter INPUT_SIZE = 4096,
    parameter OUTPUT_SIZE = 128,
    parameter DATA_WIDTH = 8
)(
    input  [DATA_WIDTH*INPUT_SIZE-1:0] input_data,            // Flattened input data
    input  [DATA_WIDTH*INPUT_SIZE*OUTPUT_SIZE-1:0] weights,   // Flattened weights
    input  [DATA_WIDTH*OUTPUT_SIZE-1:0] biases,               // Flattened biases
    output reg [DATA_WIDTH*OUTPUT_SIZE-1:0] output_data       // Flattened output data
);

    integer i, j;
    reg signed [15:0] accum; // Accumulator for each output neuron

    always @(*) begin
        // Loop over each neuron in the output layer
        for (j = 0; j < OUTPUT_SIZE; j = j + 1) begin
            // Initialize with the bias for the neuron
            accum = biases[j*DATA_WIDTH +: DATA_WIDTH];

            // Multiply-Accumulate operation for each input
            for (i = 0; i < INPUT_SIZE; i = i + 1) begin
                // Access individual weight and input value in flattened arrays
                accum = accum + 
                        (input_data[i*DATA_WIDTH +: DATA_WIDTH] * 
                         weights[(j * INPUT_SIZE + i) * DATA_WIDTH +: DATA_WIDTH]);
            end

            // Store the accumulated output in the flattened output_data
            output_data[j*DATA_WIDTH +: DATA_WIDTH] = accum[DATA_WIDTH-1:0]; // Adjust as per your bit-width requirements
        end
    end
endmodule




