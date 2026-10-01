module uart_rx #(
    parameter CLK = 27_000_000,
    parameter UART_BAUD = 115200,
    parameter OVERSAMPLE = 8
) (
    input clk,

    input rst,

    input uart_rx,

    output reg [7:0] rx_byte = 0,
    output reg rx_ready = 0,
    output reg error = 0
);
  localparam DIVIDER = CLK / (UART_BAUD * OVERSAMPLE);
  localparam BAUD_ACTUAL = CLK / (DIVIDER * OVERSAMPLE);

  localparam STATE_UNKNOWN = 4;
  localparam STATE_IDLE = 0;
  localparam STATE_EXPECT_START = 1;
  localparam STATE_DATA = 2;
  localparam STATE_EXPECT_STOP = 3;

  reg [2:0] state = STATE_UNKNOWN;

  reg [31:0] clk_counter = 0;

  // TODO Make this handle higher oversample
  reg [3:0] sample_0 = 0;
  reg [3:0] sample_1 = 0;
  // TODO How to deal with tie?
  wire sampled_bit = sample_0 > sample_1 ? 0 : 1;

  reg [7:0] data = 0;
  reg [2:0] data_counter = 0;

  always @(posedge clk) begin
    case (state)
      STATE_UNKNOWN: begin
        rx_ready <= 0;
        if (uart_rx == 1) state <= STATE_IDLE;
      end
      STATE_IDLE: begin
        rx_ready <= 0;
        if (uart_rx == 0) begin
          state <= STATE_EXPECT_START;
          clk_counter <= 0;
          sample_0 <= 0;
          sample_1 <= 0;
          error <= 0;
        end
      end
    endcase

    if (clk_counter >= DIVIDER - 1) begin
      clk_counter <= 0;

      if (uart_rx == 0) sample_0 <= sample_0 + 1;
      if (uart_rx == 1) sample_1 <= sample_1 + 1;

    end else if (state != STATE_UNKNOWN && state != STATE_IDLE) clk_counter <= clk_counter + 1;

    if (sample_0 + sample_1 >= OVERSAMPLE) begin
      sample_0 <= 0;
      sample_1 <= 0;

      case (state)
        STATE_EXPECT_START:
        if (sampled_bit == 0) begin
          state <= STATE_DATA;
          data <= 0;
          data_counter <= 0;
        end else begin
          state <= STATE_UNKNOWN;
          error <= 1;
        end

        STATE_DATA: begin
          if (data_counter == 7) state <= STATE_EXPECT_STOP;
          data_counter <= data_counter + 1;
          data <= {sampled_bit, data[7:1]};
        end
        STATE_EXPECT_STOP:
        if (sampled_bit == 1) begin
          state <= STATE_IDLE;
          rx_byte <= data;
          rx_ready <= 1;
        end else begin
          state <= STATE_UNKNOWN;
          error <= 1;
        end

      endcase
    end
  end

endmodule



