`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2024 19:09:36
// Design Name: 
// Module Name: top_level_tb
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


module top_level_tb;

    // Parameters
    parameter INPUT_SIZE = 4096;
    parameter HIDDEN_SIZE = 128;
    parameter OUTPUT_SIZE = 1;
    parameter DATA_WIDTH = 8;

    // Clock and reset signals
    reg clk;
    reg rst;

    // Flattened pixel data input
    reg [DATA_WIDTH*INPUT_SIZE-1:0] pixel_data_flat;

    // Temporary memory array for image data
    reg [DATA_WIDTH-1:0] pixel_data_mem [0:INPUT_SIZE-1];

    // Output from the neural network
    wire [0:0] inference_output;

    // Instantiate the top_level module
    top_level #(
        .INPUT_SIZE(INPUT_SIZE),
        .HIDDEN_SIZE(HIDDEN_SIZE),
        .OUTPUT_SIZE(OUTPUT_SIZE),
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .pixel_data_flat(pixel_data_flat),
        .inference_output(inference_output)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Load input images and test the network
    integer i;
    initial begin
        // Initialize reset
        rst = 1;
        #10;
        rst = 0;

        // Test image with crack
        $display("Testing image with crack...");
        $readmemh("test_image1.hex", pixel_data_mem);
        #10;

        // Flatten the data from pixel_data_mem into pixel_data_flat
        for (i = 0; i < INPUT_SIZE; i = i + 1) begin
            pixel_data_flat[i*DATA_WIDTH +: DATA_WIDTH] = pixel_data_mem[i];
        end
        #10; // Wait for a few cycles for processing
        $display("Inference Output for Crack Image: %b", inference_output);

        // Test image without crack
        $display("Testing image without crack...");
        $readmemh("test_image2.hex", pixel_data_mem);
        #10;

        // Flatten the data from pixel_data_mem into pixel_data_flat
        for (i = 0; i < INPUT_SIZE; i = i + 1) begin
            pixel_data_flat[i*DATA_WIDTH +: DATA_WIDTH] = pixel_data_mem[i];
        end
        #10; // Wait for a few cycles for processing
        $display("Inference Output for Non-Crack Image: %b", inference_output);

        // Finish the simulation
        $finish;
    end

endmodule


