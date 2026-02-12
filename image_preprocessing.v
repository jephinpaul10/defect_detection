`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2024 14:04:45
// Design Name: 
// Module Name: image_preprocessing
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


module image_preprocessing (
    input [16:0] addr,   // Address input
    output reg [7:0] pixel_value  // Pixel value output
);

// Memory array to store image pixel data
reg [7:0] image_memory [0:16384];  // Assuming 128x128 grayscale image

// Read memory from the hex file at simulation start
initial begin
    $readmemh("test_image1.hex", image_memory);
end

// Output pixel value based on the address
always @ (addr) begin
    pixel_value = image_memory[addr];
end
endmodule
