module uart_rx #(
    parameter CLK = 27_000_000,
    parameter UART_BAUD = 115200,
    parameter OVERSAMPLE = 8
) (
    input clk,

    input rst,

    input uart_rx,

    output reg rx_byte = 0,
    output reg rx_ready = 0
);
  localparam DIVIDER = CLK / (UART_BAUD * OVERSAMPLE);
  localparam BAUD_ACTUAL = CLK / (DIVIDER * OVERSAMPLE);

  localparam STATE_UNKNOWN = 4;
  localparam STATE_IDLE = 0;
  localparam STATE_EXPECT_START = 1;

  reg [2:0] state = STATE_UNKNOWN;

  always @(posedge clk) begin
    case (state)
      STATE_UNKNOWN:
      if (uart_rx == 1) begin
        state <= STATE_IDLE;
        rx_ready <= 0;
      end
      STATE_IDLE:
      if (uart_rx == 0) begin
        state <= STATE_UNKNOWN;
        rx_ready <= 1;
      end
    endcase
  end

endmodule



