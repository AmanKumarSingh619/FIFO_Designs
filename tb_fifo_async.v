`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2025 22:49:47
// Design Name: 
// Module Name: tb_fifo_async
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

module tb_fifo_async;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;

    // Testbench Signals
    reg wr_clk, rd_clk, rst;
    reg wr_en, rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire full, empty;

    // Instantiate DUT
    fifo_async #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock Generation
    initial wr_clk = 0;
    always #5 wr_clk = ~wr_clk; // Write clock: 10ns period

    initial rd_clk = 0;
    always #7 rd_clk = ~rd_clk; // Read clock: 14ns period

    // Test Sequence
    initial begin
        // Open simulation log
        $dumpfile("fifo_async.vcd");
        $dumpvars(0, tb_fifo_async);

        // Initialize signals
        rst = 1; wr_en = 0; rd_en = 0; data_in = 0;
        #20 rst = 0; // Release reset after 20ns

        // Test 1: Write to FIFO
        $display("Starting Write Test...");
        repeat (DEPTH) begin
            @(posedge wr_clk);
            wr_en = 1;
            data_in = $random;
            #1 if (full) $display("FIFO Full: Data not written at %0dns", $time);
        end
        wr_en = 0;

        // Test 2: Read from FIFO
        $display("Starting Read Test...");
        repeat (DEPTH) begin
            @(posedge rd_clk);
            rd_en = 1;
            #1 if (empty) $display("FIFO Empty: Data not read at %0dns", $time);
        end
        rd_en = 0;

        // Test 3: Simultaneous Write and Read
        $display("Starting Simultaneous Write and Read Test...");
        repeat (DEPTH) begin
            @(posedge wr_clk);
            wr_en = 1; data_in = $random;
            @(posedge rd_clk);
            rd_en = 1;
        end
        wr_en = 0; rd_en = 0;

        // Test 4: Overflow Test
        $display("Starting Overflow Test...");
        repeat (DEPTH + 2) begin
            @(posedge wr_clk);
            wr_en = 1; data_in = $random;
        end
        wr_en = 0;

        // Test 5: Underflow Test
        $display("Starting Underflow Test...");
        repeat (DEPTH + 2) begin
            @(posedge rd_clk);
            rd_en = 1;
        end
        rd_en = 0;

        // End simulation
        $display("Test Completed.");
        $finish;
    end
endmodule