`timescale 1ns / 1ps
;

module uart_rx_tb;
  reg clk;

  reg rst = 0;
  reg enable = 0;
  wire uart_tx;
  reg [7:0] tx_byte = 0;
  wire [7:0] rx_byte;
  wire rx_ready;
  wire rx_error;
  wire tx_busy;

  uart_tx tx (
      .clk(clk),
      .rst(rst),
      .uart_tx(uart_tx),
      .tx_enable(enable),
      .tx_byte(tx_byte),
      .busy(tx_busy)
  );

  uart_rx rx (
      .clk(clk),
      .rst(rst),
      .uart_rx(uart_tx),
      .rx_byte(rx_byte),
      .rx_ready(rx_ready),
      .error(rx_error)
  );

  // 10 ns clock period
  initial begin
    clk = 0;
    forever begin
      #5 clk = ~clk;
      #5 clk = ~clk;
    end
  end

  initial begin
    $dumpfile("uart_rx.vcd");
    $dumpvars(0, uart_rx_tb);
  end

  initial begin
    $monitor(
        "time=%0t clk=%d enable=%d tx=%d tx_byte=%d rx_byte=%d rx_ready=%d rx_error=%d tx_busy=%d",
        $time, clk, enable, uart_tx, tx_byte, rx_byte, rx_ready, rx_error, tx_busy);

    rst = 1;
    #10;
    rst = 0;
    enable = 1;
    tx_byte = 8'h41;

    #23000
    tx_byte = 8'h42;

    #23000
    tx_byte = 8'h43;

    #23000
    tx_byte = 8'h44;

    #23000
    tx_byte = 8'h45;

    #100000 $finish;
  end
endmodule
