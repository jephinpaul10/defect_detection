`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2024 21:45:29
// Design Name: 
// Module Name: weights_storage
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


module weights_storage #(
    parameter INPUT_SIZE = 4096,
    parameter HIDDEN_SIZE = 128,
    parameter DATA_WIDTH = 8
)(
    input clk,                               // Clock signal
    input rst,                               // Reset signal
    output reg [DATA_WIDTH*INPUT_SIZE*HIDDEN_SIZE-1:0] weights1, // Weights for layer 1
    output reg [DATA_WIDTH*HIDDEN_SIZE*1-1:0] weights2          // Weights for layer 2 (assuming OUTPUT_SIZE=1)
);
    // Internal storage for weights
    reg [DATA_WIDTH-1:0] temp_weights1 [0:INPUT_SIZE-1][0:HIDDEN_SIZE-1]; // 2D array for layer 1 weights
    reg [DATA_WIDTH-1:0] temp_weights2 [0:HIDDEN_SIZE-1][0:0];             // 2D array for layer 2 weights (assuming OUTPUT_SIZE=1)

    // Initialize weights from hex files
    initial begin
        $readmemh("layer_0_weights.hex", temp_weights1);
        $readmemh("layer_1_weights.hex", temp_weights2);
    end

    // Update output weights on clock edge
    integer k, l;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            weights1 <= 0;
            weights2 <= 0;
        end else begin
            // Flatten weights1
             // Declare loop variables before the procedural block
            for (k = 0; k < INPUT_SIZE; k = k + 1) begin
                for (l = 0; l < HIDDEN_SIZE; l = l + 1) begin
                    weights1[(k * HIDDEN_SIZE + l) * DATA_WIDTH +: DATA_WIDTH] <= temp_weights1[k][l];
                end
            end
            
            // Flatten weights2
            for (k = 0; k < HIDDEN_SIZE; k = k + 1) begin
                weights2[k * DATA_WIDTH +: DATA_WIDTH] <= temp_weights2[k][0]; // Assuming OUTPUT_SIZE=1
            end
        end
    end
endmodule



