`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2025 21:29:04
// Design Name: 
// Module Name: fifo_async
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

module fifo_async #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire wr_clk,                // Write clock
    input wire rd_clk,                // Read clock
    input wire rst,                   // Reset
    input wire wr_en,                 // Write enable
    input wire rd_en,                 // Read enable
    input wire [DATA_WIDTH-1:0] data_in, // Data input
    output reg [DATA_WIDTH-1:0] data_out, // Data output
    output reg full,                  // Full flag
    output reg empty                  // Empty flag
);

    // Memory array
    reg [DATA_WIDTH-1:0] fifo_mem [DEPTH-1:0];
    reg [$clog2(DEPTH):0] wr_ptr = 0, rd_ptr = 0; // Pointers with extra bit for wrap-around detection

    // Synchronized pointers
    reg [$clog2(DEPTH):0] wr_ptr_gray, rd_ptr_gray;
    reg [$clog2(DEPTH):0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;
    reg [$clog2(DEPTH):0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;

    // Convert binary pointers to Gray code
    function [$clog2(DEPTH):0] bin2gray(input [$clog2(DEPTH):0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Convert Gray code back to binary
    function [$clog2(DEPTH):0] gray2bin(input [$clog2(DEPTH):0] gray);
        integer i;
        begin
            gray2bin = gray;
            for (i = 1; i <= $clog2(DEPTH); i = i + 1)
                gray2bin = gray2bin ^ (gray >> i);
        end
    endfunction

    // Write domain logic
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            wr_ptr_gray <= 0;
            full <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr[$clog2(DEPTH)-1:0]] <= data_in; // Write data
            wr_ptr <= wr_ptr + 1;
            wr_ptr_gray <= bin2gray(wr_ptr);
        end
        // Full flag logic
        full <= (bin2gray(wr_ptr + 1) == rd_ptr_gray_sync2);
    end

    // Read domain logic
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            rd_ptr_gray <= 0;
            empty <= 1;
        end else if (rd_en && !empty) begin
            data_out <= fifo_mem[rd_ptr[$clog2(DEPTH)-1:0]]; // Read data
            rd_ptr <= rd_ptr + 1;
            rd_ptr_gray <= bin2gray(rd_ptr);
        end
        // Empty flag logic
        empty <= (wr_ptr_gray_sync2 == rd_ptr_gray);
    end

    // Synchronize pointers across clock domains
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            rd_ptr_gray_sync1 <= 0;
            rd_ptr_gray_sync2 <= 0;
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            wr_ptr_gray_sync1 <= 0;
            wr_ptr_gray_sync2 <= 0;
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

endmodule