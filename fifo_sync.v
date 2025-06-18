`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2025 07:39:34
// Design Name: 
// Module Name: fifo_sync
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

module fifo_sync #(
    parameter DATA_WIDTH = 64,
    parameter DEPTH = 1024
)(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);

    // Memory array
    reg [DATA_WIDTH-1:0] fifo_mem [DEPTH-1:0];
    reg [$clog2(DEPTH):0] rd_ptr = 0, wr_ptr = 0;
    reg [$clog2(DEPTH):0] count = 0;

    // Synchronous write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            count <= 0;
            full <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr] <= data_in;
            wr_ptr <= (wr_ptr + 1) % DEPTH;
            count <= count + 1;
        end
        full <= (count == DEPTH);
    end

    // Synchronous read
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            count <= 0;
            empty <= 1;
        end else if (rd_en && !empty) begin
            data_out <= fifo_mem[rd_ptr];
            rd_ptr <= (rd_ptr + 1) % DEPTH;
            count <= count - 1;
        end
        empty <= (count == 0);
    end
endmodule