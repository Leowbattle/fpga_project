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
  wire [7:0] tx_count;

  reg tx_enable;

  localparam ASCII_A  = 8'd65;
  localparam ASCII_Z  = 8'd90;
	localparam ASCII_CR = 8'd13;
  localparam ASCII_LF = 8'd10;

  reg [7:0] char = ASCII_A;

  always @(posedge clk) begin
    if (key1 && tx_count < 32) begin
      tx_enable <= 1;

      if (char == ASCII_Z) char <= ASCII_CR;
      else if (char == ASCII_CR) char <= ASCII_LF;
			else if (char == ASCII_LF) char <= ASCII_A;
      else char <= char + 1;
    end else begin
      tx_enable = 0;
    end
  end

  uart_tx #(
      .CLK(27_000_000),
      .UART_BAUD(115200),
      .FIFO_SIZE(32)
  ) stdout (
      .clk(clk),
      .rst(key1),
      .uart_tx(uart_tx),
      .tx_enable(tx_enable),
      .tx_byte(char),
      .tx_count(tx_count)
  );

endmodule
