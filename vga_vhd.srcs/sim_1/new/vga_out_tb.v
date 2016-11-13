`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/10/23 19:01:48
// Design Name: 
// Module Name: display_cont_tb
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

//`include "display_cont.v"

module vga_out_tb(
    );
    
    reg OSC50M;
    reg RST;
    wire VSYNCX;
    wire HSYNCX;
    wire [3:0] RED;
    wire [3:0] GREEN;
    wire [3:0] BLUE;

    parameter   OSC50M_PERIOD   = 20000;    // ps

    vga_out vga_out_0(OSC50M, RST, VSYNCX, HSYNCX, RED, GREEN, BLUE);

    //clock
    initial begin
        OSC50M = 1'b0;
    end

    always #(OSC50M_PERIOD/2) begin
        OSC50M  <= ~OSC50M;
    end

    //reset
    initial begin
        RST = 1;
        repeat(20) @(negedge OSC50M);
        RST = 0;
    end
    
endmodule