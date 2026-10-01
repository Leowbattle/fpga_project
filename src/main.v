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
  assign led0 = uart_rx;
  assign led1 = uart_tx;
  assign led2 = 1'b1;
  assign led3 = 1'b1;
  assign led4 = 1'b1;
  assign led5 = 1'b1;

  wire rx_ready;
  wire [7:0] rx_byte;
  wire [7:0] tx_byte;

  reg tx_enable;

  wire in_consumed;
  wire out_ready;
  reg out_consumed;

  always @(posedge clk) begin
    if (out_ready) begin
      tx_enable <= 1;
      out_consumed <= 1;
    end else begin
      tx_enable <= 0;
      out_consumed <= 0;
    end
  end

  // This is okay as long as calc is ready for input before rx receives more data
  // For this it will, so we won't bother checking in_consumed
  rpn_calc calc (
      .clk(clk),
      .rst(key2),
      .in_byte(rx_byte),
      .in_available(rx_ready),
      .in_consumed(in_consumed),
      .out_byte(tx_byte),
      .out_ready(out_ready),
      .out_consumed(out_consumed)
  );

  uart_tx #(
      .CLK(27_000_000),
      .UART_BAUD(115200)
  ) stdout (
      .clk(clk),
      .rst(key2),
      .uart_tx(uart_tx),
      .tx_enable(tx_enable),
      .tx_byte(tx_byte),
      .busy(busy)
  );

  uart_rx #(
      .CLK(27_000_000),
      .UART_BAUD(115200)
  ) stdin (
      .clk(clk),
      .rst(key2),
      .uart_rx(uart_rx),
      .rx_byte(rx_byte),
      .rx_ready(rx_ready)
  );

endmodule
