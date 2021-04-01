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
      signed_ope = '0;
      start = 1;
  
      @(posedge clk);
      #1;
      start = 0;
  
      @(posedge clk);
      wait(ready);
      @(posedge clk);
      $display("%d / %d = %d ... %d", dividend, divisor, quotient, remainder);
      if (quotient != dividend / divisor) begin
        $display("NG");
        fail = 1;
      end
    end

    if (fail) $display("FAIL");
    else      $display("PASS");

    $finish;
  end
