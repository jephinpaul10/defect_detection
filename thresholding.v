`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2024 09:50:55
// Design Name: 
// Module Name: thresholding
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


module thresholding #(
    parameter INPUT_SIZE = 4096,
    parameter DATA_WIDTH = 8
)(
    input  [DATA_WIDTH*INPUT_SIZE-1:0] pixel_in,        // Flattened input pixel data
    input  [DATA_WIDTH-1:0] threshold_value,            // 8-bit threshold value
    output [DATA_WIDTH*INPUT_SIZE-1:0] pixel_out        // Flattened thresholded output
);

    genvar i;
    generate
        for (i = 0; i < INPUT_SIZE; i = i + 1) begin : thresholding_loop
            assign pixel_out[i*DATA_WIDTH +: DATA_WIDTH] = 
                (pixel_in[i*DATA_WIDTH +: DATA_WIDTH] >= threshold_value) ? 8'hFF : 8'h00;
        end
    endgenerate

endmodule


