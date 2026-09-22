module blink (
    input  clk,   // 27 MHz clock
    output led0,
    output led1,
    output led2,
    output led3,
    output led4,
    output led5,

    input key1,
    input key2,

    input  uart_rx,
    output uart_tx
);
  reg rst = 0;

  wire [7:0] tx_count;
  wire [7:0] rx_count;
  wire [7:0] rx_byte;

  // wire xxx;
  // assign led0 = ~xxx;
  // assign uart_tx = xxx;

  uart #(
      .CLK(27_000_000),
      .UART_BAUD(115200),
      .OVERSAMPLE(1),
      .FIFO_SIZE(32)
  ) stdout (
      .clk(clk),
      .rst(rst),
      .uart_rx(uart_rx),
      .uart_tx(uart_tx),
      .tx_enable(1),
      .tx_byte(8'd65),
      .tx_count(tx_count),
      .rx_enable(0),
      .rx_byte(rx_byte),
      .rx_count(rx_count)
  );

endmodule
