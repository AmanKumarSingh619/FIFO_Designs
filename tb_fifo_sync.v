`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2025 07:41:21
// Design Name: 
// Module Name: tb_fifo_sync
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

module tb_fifo_sync;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;

    // Testbench Signals
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;

    // DUT Instantiation
    fifo_sync #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns clock period

    // Test Sequence
    initial begin
        // Open simulation log
        $dumpfile("fifo_sync.vcd");
        $dumpvars(0, tb_fifo_sync);

        // Initialize signals
        rst = 1; wr_en = 0; rd_en = 0; data_in = 0;
        #20 rst = 0; // Release reset after 20ns

        // Test 1: Write to FIFO
        $display("Starting Write Test...");
        repeat (DEPTH) begin
            @(posedge clk);
            wr_en = 1;
            data_in = $random;
            #1 if (full) $display("FIFO Full: Data not written at %0dns", $time);
        end
        wr_en = 0;

        // Test 2: Read from FIFO
        $display("Starting Read Test...");
        repeat (DEPTH) begin
            @(posedge clk);
            rd_en = 1;
            #1 if (empty) $display("FIFO Empty: Data not read at %0dns", $time);
        end
        rd_en = 0;

        // Test 3: Simultaneous Write and Read
        $display("Starting Simultaneous Write and Read Test...");
        repeat (DEPTH) begin
            @(posedge clk);
            wr_en = 1; rd_en = 1;
            data_in = $random;
        end
        wr_en = 0; rd_en = 0;

        // Test 4: Overflow Test
        $display("Starting Overflow Test...");
        repeat (DEPTH + 2) begin
            @(posedge clk);
            wr_en = 1;
            data_in = $random;
        end
        wr_en = 0;

        // Test 5: Underflow Test
        $display("Starting Underflow Test...");
        repeat (DEPTH + 2) begin
            @(posedge clk);
            rd_en = 1;
        end
        rd_en = 0;

        // End simulation
        $display("Test Completed.");
        $finish;
    end
endmodule