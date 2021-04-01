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
    #D1;
    rst_n = '1;

    @(posedge clk);
    #D1;
    dividend = 13;
    divisor = 4;
    signed_ope = '0;
    start = 1;

    @(posedge clk);
    #D1;
    start = 1'b0;

    repeat(2) @(posedge clk);
    #D1;
    flush = 1'b1;

    @(posedge clk);
    #D1;
    flush = 1'b0;

    @(posedge clk);
    if (~ready) fail = 1;

    if (fail) $display("FAIL");
    else      $display("PASS");

    $finish;
  end

