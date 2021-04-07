`timescale 1ns / 1ps
module div #(
    parameter int unsigned DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst_n,
    input logic [DATA_WIDTH-1:0] dividend,
    input logic [DATA_WIDTH-1:0] divisor,
    input logic signed_ope,
    input logic start,
    input logic flush,
    output logic [DATA_WIDTH-1:0] quotient,
    output logic [DATA_WIDTH-1:0] remainder,
    output logic ready
);
  localparam int unsigned D1 = 1;
  localparam int unsigned COUNT_WIDTH = $clog2(DATA_WIDTH + 1);

  logic r_ready;
  logic r_signed_ope;
  logic [COUNT_WIDTH-1:0] r_count;
  logic [DATA_WIDTH-1:0] r_quotient;
  logic w_dividend_sign;
  logic r_dividend_sign;
  logic remainder_sign;
  logic [DATA_WIDTH:0] r_remainder;
  logic [DATA_WIDTH-1:0] r_divisor;
  logic [DATA_WIDTH:0] divisor_ext;
  logic divisor_sign;
  logic [DATA_WIDTH:0] rem_quo;
  logic                diff_sign;
  logic [DATA_WIDTH:0] sub_add;

  assign ready = r_ready;

  assign divisor_sign = r_divisor[DATA_WIDTH-1] & r_signed_ope;
  assign divisor_ext = {divisor_sign, r_divisor};
  assign remainder_sign = r_remainder[DATA_WIDTH];

  assign rem_quo = {r_remainder[DATA_WIDTH-1:0], r_quotient[DATA_WIDTH-1]};
  assign diff_sign = remainder_sign ^ divisor_sign;
  assign sub_add = diff_sign ? rem_quo + divisor_ext :
                               rem_quo - divisor_ext;

  // after process
  always_comb begin
    quotient  = (r_quotient << 1) | 1;
    remainder = r_remainder[DATA_WIDTH-1:0];

    if (r_remainder == 0) begin
      // do nothing
    end else if (r_remainder == divisor_ext) begin
      quotient  = quotient + 1;
      remainder = remainder - r_divisor;
    end else if (r_remainder == -divisor_ext) begin
      quotient  = quotient - 1;
      remainder = remainder + r_divisor;
    end else if (remainder_sign ^ r_dividend_sign) begin
      if (diff_sign) begin
        quotient  = quotient - 1;
        remainder = remainder + r_divisor;
      end else begin
        quotient  = quotient + 1;
        remainder = remainder - r_divisor;
      end
    end
  end

  assign w_dividend_sign = dividend[DATA_WIDTH-1] & signed_ope;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      r_quotient      <= #D1 '0;
      r_dividend_sign <= #D1 '0;
      r_remainder     <= #D1 '0;
      r_divisor       <= #D1 '0;
      r_count         <= #D1 '0;
      r_ready         <= #D1 1'b1;
      r_signed_ope    <= #D1 1'b0;
    end else begin
      if (flush) begin
        r_count         <= #D1 '0;
        r_ready         <= #D1 1'b1;
      end else if (start) begin
        // RISC-V's div by 0 spec
        if (divisor == '0) begin
            r_quotient  <= #D1 '1;
            r_remainder <= #D1 {w_dividend_sign, dividend};
        end else begin
            r_quotient  <= #D1 dividend;
            r_remainder <= #D1 {(DATA_WIDTH+1){w_dividend_sign}};
            r_ready     <= #D1 1'b0;
        end
        r_count         <= #D1 '0;
        r_dividend_sign <= #D1 w_dividend_sign;
        r_divisor       <= #D1 divisor;
        r_signed_ope    <= #D1 signed_ope;
      end else if (~ready) begin
        r_quotient  <= #D1 {r_quotient[DATA_WIDTH-2:0], ~diff_sign};
        r_remainder <= #D1 sub_add[DATA_WIDTH:0];
        r_count     <= #D1 r_count + 1;
        if (r_count == DATA_WIDTH - 1) begin
          r_ready <= #D1 1'b1;
        end
      end
    end
  end
endmodule

