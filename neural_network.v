`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2024 10:07:41
// Design Name: 
// Module Name: neural_network
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


module neural_network #(
    parameter INPUT_SIZE = 4096,
    parameter HIDDEN_SIZE = 128,
    parameter OUTPUT_SIZE = 1,
    parameter DATA_WIDTH = 8
)(
    input [DATA_WIDTH-1:0] pixel_data [0:INPUT_SIZE-1],
    input [DATA_WIDTH-1:0] weights1 [0:INPUT_SIZE-1][0:HIDDEN_SIZE-1],
    input [DATA_WIDTH-1:0] biases1 [0:HIDDEN_SIZE-1],
    input [DATA_WIDTH-1:0] weights2 [0:HIDDEN_SIZE-1][0:OUTPUT_SIZE-1],
    input [DATA_WIDTH-1:0] biases2 [0:OUTPUT_SIZE-1],
    output [0:0] binary_output
);

    // Intermediate signals
    wire signed [DATA_WIDTH-1:0] layer1_out [0:HIDDEN_SIZE-1];
    wire signed [DATA_WIDTH-1:0] activated_layer1_out [0:HIDDEN_SIZE-1];
    wire signed [DATA_WIDTH-1:0] layer2_out [0:OUTPUT_SIZE-1];

    // Layer 1: Dense + ReLU
    dense_layer #(INPUT_SIZE, HIDDEN_SIZE, DATA_WIDTH) dense1 (
        .input_data(pixel_data),
        .weights(weights1),
        .biases(biases1),
        .output_data(layer1_out)
    );

    relu_activation #(HIDDEN_SIZE, DATA_WIDTH) relu1 (
        .input_data(layer1_out),
        .output_data(activated_layer1_out)
    );

    // Layer 2: Dense + Sigmoid
    dense_layer #(HIDDEN_SIZE, OUTPUT_SIZE, DATA_WIDTH) dense2 (
        .input_data(activated_layer1_out),
        .weights(weights2),
        .biases(biases2),
        .output_data(layer2_out)
    );

    sigmoid_activation #(OUTPUT_SIZE, DATA_WIDTH) sigmoid1 (
        .input_data(layer2_out[0]),
        .binary_output(binary_output)
    );
    initial begin
        // Load weights and biases for Layer 1
        $readmemh("layer_0_weights.hex", weights1); // Adjust indexing if necessary
        $readmemh("layer_0_biases.hex", biases1);

        // Load weights and biases for Layer 2
        $readmemh("layer_1_weights.hex", weights2);
        $readmemh("layer_1_biases.hex", biases2);
    end

endmodule
