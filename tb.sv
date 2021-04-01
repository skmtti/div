`timescale 1ns/1ps

module tb;
  localparam int unsigned DATA_WIDTH=5;
  localparam int unsigned D1 = 1;
  logic clk;
  logic rst_n;
  logic [DATA_WIDTH-1:0] dividend;
  logic [DATA_WIDTH-1:0] divisor;
  logic signed_ope;
  logic start;
  logic flush;
  logic [DATA_WIDTH-1:0] quotient;
  logic [DATA_WIDTH-1:0] remainder;
  logic ready;

  div #(.DATA_WIDTH(DATA_WIDTH))div (.*);

  always #5 clk = ~clk;

  logic [DATA_WIDTH*2:0] count;
  logic [DATA_WIDTH*2:0] max_count = ({1'b1, {(DATA_WIDTH*2){1'b0}}});
  bit   fail = 0;

  initial begin
    $dumpfile("wave.fst");
    $dumpvars(0, tb);
  end

  `include "test.h"

endmodule

