module uart #(
    parameter CLK = 27_000_000,
    parameter UART_BAUD = 115200,
    parameter OVERSAMPLE = 8
) (
    input clk
);
  localparam DIVIDER = CLK / (OVERSAMPLE * UART_BAUD);
  localparam BAUD_ACTUAL = CLK / (OVERSAMPLE * DIVIDER);

endmodule

