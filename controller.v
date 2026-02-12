`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2024 10:39:46
// Design Name: 
// Module Name: controller
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


module nn_controller (
    input clk,
    input reset,
    output reg layer1_enable,
    output reg layer2_enable,
    output reg result_ready
);
    reg [2:0] state;

    // State definitions
    parameter IDLE = 3'b000;
    parameter LAYER1 = 3'b001;
    parameter LAYER1_ACTIVATION = 3'b010;
    parameter LAYER2 = 3'b011;
    parameter LAYER2_ACTIVATION = 3'b100;
    parameter DONE = 3'b101;

    // State machine to manage control signals
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            layer1_enable <= 0;
            layer2_enable <= 0;
            result_ready <= 0;
        end else begin
            case (state)
                IDLE: begin
                    layer1_enable <= 1;
                    state <= LAYER1;
                end
                LAYER1: begin
                    layer1_enable <= 0;
                    state <= LAYER1_ACTIVATION;
                end
                LAYER1_ACTIVATION: begin
                    layer2_enable <= 1;
                    state <= LAYER2;
                end
                LAYER2: begin
                    layer2_enable <= 0;
                    state <= LAYER2_ACTIVATION;
                end
                LAYER2_ACTIVATION: begin
                    result_ready <= 1;
                    state <= DONE;
                end
                DONE: begin
                    // Maintain result until reset
                    result_ready <= 1;
                end
            endcase
        end
    end
endmodule

