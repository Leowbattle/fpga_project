module main (
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
  wire busy;
  assign led0 = ~busy;
  assign led1 = uart_rx;
  assign led2 = 1'b1;
  assign led3 = 1'b1;
  assign led4 = 1'b1;
  assign led5 = uart_tx;

  wire tx_enable;

  localparam ASCII_A  = 8'd65;

  reg [7:0] char = ASCII_A;

  wire rx_ready;
  wire [7:0] rx_byte;

  assign tx_enable = rx_ready;

  uart_tx #(
      .CLK(27_000_000),
      .UART_BAUD(115200)
  ) stdout (
      .clk(clk),
      .rst(key2),
      .uart_tx(uart_tx),
      .tx_enable(tx_enable),
      .tx_byte(char),
      .busy(busy)
  );

  uart_rx #(
      .CLK(27_000_000),
      .UART_BAUD(115200)
  ) stdin (
    .clk(clk),
    .rst(rst),
    .uart_rx(uart_rx),
    .rx_byte(rx_byte),
    .rx_ready(rx_ready)
  );

endmodule
