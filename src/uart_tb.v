`timescale 1ns / 1ps
;

module uart_tb;

  reg clk;
  reg rst = 0;
  wire uart_rx;
  wire uart_tx;
  wire [7:0] tx_count;
  wire [7:0] rx_count;
  wire [7:0] rx_byte;

  uart #(
      .CLK(100_000_000),
      .UART_BAUD(115200),
      .OVERSAMPLE(1),
      .FIFO_SIZE(32)
  ) dut (
      .clk(clk),
      .rst(rst),
      .uart_rx(uart_rx),
      .uart_tx(uart_tx),
      .tx_enable(1'b1),
      .tx_byte(8'd97),
      .tx_count(tx_count),
      .rx_enable(1'b0),
      .rx_byte(rx_byte),
      .rx_count(rx_count)
  );

  // 10 ns clock period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);
  end

  initial begin
    $monitor("time=%0t clk=%d rst=%d uart_tx=%d state=%d data_counter=%d data=%d clk_counter=%d",
             $time, clk, rst, uart_tx, dut.state, dut.data_counter, dut.data, dut.clk_counter);

    rst = 1;
    #10;

    rst = 0;

    #10000;
    #10000;
    #10000;
    #10000;
    #10000;
    #10000;
    #10000;
    #10000;
    #10000;
    #10000 $finish;
  end
endmodule
