`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2024 12:04:06
// Design Name: 
// Module Name: top_level
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


module top_level #(
    parameter INPUT_SIZE = 4096,
    parameter HIDDEN_SIZE = 128,
    parameter OUTPUT_SIZE = 1,
    parameter DATA_WIDTH = 8
)(
    input clk,                       // Clock input for synchronous operation
    input rst,                       // Reset signal
    input [DATA_WIDTH*INPUT_SIZE-1:0] pixel_data_flat,  // Image input data (flattened)
    output wire [0:0] inference_output // Final binary inference output (flattened to single bit)
);
    wire [DATA_WIDTH*INPUT_SIZE*HIDDEN_SIZE-1:0] weights1; // Weights for first layer
    wire [DATA_WIDTH*HIDDEN_SIZE*OUTPUT_SIZE-1:0] weights2; // Weights for second layer
    
    weights_storage #(
        .INPUT_SIZE(INPUT_SIZE),
        .HIDDEN_SIZE(HIDDEN_SIZE),
        .DATA_WIDTH(DATA_WIDTH)
    ) weights_inst (
        .clk(clk),
        .rst(rst),
        .weights1(weights1),
        .weights2(weights2)
    );

    // Internal signal declarations
    wire [DATA_WIDTH*INPUT_SIZE-1:0] flat_thresholded_data;
    wire [DATA_WIDTH*HIDDEN_SIZE-1:0] flat_layer1_out;
    wire [DATA_WIDTH*HIDDEN_SIZE-1:0] flat_activated_layer1_out;
    wire [DATA_WIDTH*OUTPUT_SIZE-1:0] flat_layer2_out;

    // Declaring weight and bias arrays (registers for loading from memory)
    //reg [DATA_WIDTH-1:0] weights1 [0:INPUT_SIZE-1][0:HIDDEN_SIZE-1];
    wire [DATA_WIDTH*INPUT_SIZE*HIDDEN_SIZE-1:0] flat_weights1;
    reg [DATA_WIDTH-1:0] biases1 [0:HIDDEN_SIZE-1];
    wire [DATA_WIDTH*HIDDEN_SIZE-1:0] flat_biases1;
    //reg [DATA_WIDTH-1:0] weights2 [0:HIDDEN_SIZE-1][0:OUTPUT_SIZE-1];
    wire [DATA_WIDTH*HIDDEN_SIZE*OUTPUT_SIZE-1:0] flat_weights2;
    reg [DATA_WIDTH-1:0] biases2 [0:OUTPUT_SIZE-1];
    wire [DATA_WIDTH*OUTPUT_SIZE-1:0] flat_biases2;

    // Load weights and biases at simulation start
    initial begin
        //$readmemh("layer_0_weights.hex", weights1);
        $readmemh("layer_0_biases.hex", biases1);
        //$readmemh("layer_1_weights.hex", weights2);
        $readmemh("layer_1_biases.hex", biases2);
    end

    genvar k,l;
    generate
        // Flatten biases1 into flat_biases1
        for (l = 0; l < HIDDEN_SIZE; l = l + 1) begin
            assign flat_biases1[l * DATA_WIDTH +: DATA_WIDTH] = biases1[l];
        end

        // Flatten biases2 into flat_biases2
        for (l = 0; l < OUTPUT_SIZE; l = l + 1) begin
            assign flat_biases2[l * DATA_WIDTH +: DATA_WIDTH] = biases2[l];
        end
    endgenerate

    // Threshold Preprocessing Module
    thresholding #(.INPUT_SIZE(INPUT_SIZE), .DATA_WIDTH(DATA_WIDTH)) preprocess (
        .pixel_in(pixel_data_flat),           // Flattened input data
        .threshold_value(8'h80),              // Threshold value
        .pixel_out(flat_thresholded_data)     // Flattened output
    );

    // Dense Layer 1 + ReLU
    dense_layer #(.INPUT_SIZE(INPUT_SIZE), .OUTPUT_SIZE(HIDDEN_SIZE), .DATA_WIDTH(DATA_WIDTH)) dense1 (
        .input_data(flat_thresholded_data),   // Flattened thresholded data
        .weights(weights1),              // Flattened weights for layer 1
        .biases(flat_biases1),                // Flattened biases for layer 1
        .output_data(flat_layer1_out)         // Flattened output from dense layer 1
    );

    // ReLU Activation for Dense Layer 1
    relu_activation #(.SIZE(HIDDEN_SIZE), .DATA_WIDTH(DATA_WIDTH)) relu1 (
        .input_data_flat(flat_layer1_out),            // Flattened input from dense layer 1
        .output_data_flat(flat_activated_layer1_out)  // Flattened ReLU output
    );

    // Dense Layer 2 + Sigmoid
    dense_layer #(.INPUT_SIZE(HIDDEN_SIZE), .OUTPUT_SIZE(OUTPUT_SIZE), .DATA_WIDTH(DATA_WIDTH)) dense2 (
        .input_data(flat_activated_layer1_out),  // Flattened input from ReLU
        .weights(weights2),                 // Flattened weights for layer 2
        .biases(flat_biases2),                   // Flattened biases for layer 2
        .output_data(flat_layer2_out)            // Flattened output from dense layer 2
    );

    // Sigmoid Activation for final output
    sigmoid_activation #(.OUTPUT_SIZE(OUTPUT_SIZE), .DATA_WIDTH(DATA_WIDTH)) sigmoid1 (
        .input_data(flat_layer2_out),            // Flattened input from dense layer 2
        .binary_output(inference_output)         // Final output as a single-bit inference result
    );

endmodule


