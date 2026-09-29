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
	assign led1 = 1'b1;
	assign led2 = 1'b1;
	assign led3 = 1'b1;
	assign led4 = 1'b1;
	assign led5 = uart_tx;

  wire tx_enable;

  localparam ASCII_A  = 8'd65;
  localparam ASCII_Z  = 8'd90;
  localparam ASCII_CR = 8'd13;
  localparam ASCII_LF = 8'd10;

  reg [7:0] char = ASCII_A;

	assign tx_enable = key1;

  always @(posedge clk) begin
    if (tx_enable && !busy) begin
      if (char == ASCII_Z) char <= ASCII_CR;
      else if (char == ASCII_CR) char <= ASCII_LF;
      else if (char == ASCII_LF) char <= ASCII_A;
      else char <= char + 1;
    end
  end

  uart_tx #(
      .CLK(27_000_000),
      .UART_BAUD(115200),
      .FIFO_SIZE(32)
  ) stdout (
      .clk(clk),
      .rst(key2),
      .uart_tx(uart_tx),
      .tx_enable(tx_enable),
      .tx_byte(char),
      .busy(busy)
  );

endmodule
