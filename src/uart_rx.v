module uart_rx #(
    parameter CLK = 27_000_000,
    parameter UART_BAUD = 115200,
    parameter OVERSAMPLE = 8
) (
    input clk,

    input rst,

    input uart_rx,

    output reg rx_byte,
    output rx_ready
);
  localparam DIVIDER = CLK / (UART_BAUD * OVERSAMPLE);
  localparam BAUD_ACTUAL = CLK / (DIVIDER * OVERSAMPLE);

endmodule



