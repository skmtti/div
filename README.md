## Signed/unsigned integer divider using non-restoring division algorithm
It takes DATA_WIDTH+1 cycles until the operation result is output.

### Parameters

parameter|discription
---|---
DATA_WIDTH|Data width of dividend and divisor|


### Interface signals


signal|I/O|width|discription
---|---|---|---
clk |I||clock
rst_n |I||asynchronous reset
dividend|I|[DATA_WIDTH-1:0]|dividend
divisor|I|[DATA_WIDTH-1:0]|divisor
signed_ope|I||0: unsigned operation, 1: signed operation
start|I||start (high pulse)
flush|I||flush internal state (high pulse)
quotient|O|[DATA_WIDTH-1:0]|quotient
remainder|O|[DATA_WIDTH-1:0]|remainder
ready|O||Indicates that qutient and remainder are ready (high level)

### Timing chart

![div wave](https://github.com/skmtti/div/blob/figure/div_wave.png)
