  logic [DATA_WIDTH-1:0] tmp_dividend;
  logic [DATA_WIDTH-1:0] tmp_divisor;
  logic [DATA_WIDTH-1:0] exp_quotient;
  logic [DATA_WIDTH-1:0] exp_remainder;

  initial begin
    clk = '0;
    rst_n = '0;
    dividend = '0;
    divisor = '0;
    signed_ope = '0;
    start = '0;
    flush = '0;
    count = '0;

    @(posedge clk);
    #1;
    rst_n = '1;

    for (count = 0; count < max_count; count++) begin
      @(posedge clk);
      #1;
      {dividend, divisor} = count;
      {tmp_dividend, tmp_divisor} = {dividend, divisor};
      signed_ope = '0;
      // div by 0 spec is RISC-V spec
      if (divisor == 0) begin
        exp_quotient = '1;
        exp_remainder = dividend; 
      end else begin
        exp_quotient = dividend / divisor;
        exp_remainder = dividend % divisor;
      end

      start = 1;
  
      @(posedge clk);
      #1;
      start = 0;
      {dividend, divisor} = 'x;
  
      @(posedge clk);
      wait(ready);
      @(posedge clk);
      $display("%d / %d = %d ... %d (%d ... %d)", 
                tmp_dividend, tmp_divisor, quotient, remainder, 
                exp_quotient, exp_remainder);
      if ((quotient  !== exp_quotient) || (remainder !== exp_remainder)) begin
        $display("NG");
        fail = 1;
      end
    end

    if (fail) $display("FAIL");
    else      $display("PASS");

    $finish;
  end
