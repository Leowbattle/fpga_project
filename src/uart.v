module uart_tx #(
    parameter CLK = 27_000_000,
    parameter UART_BAUD = 115200,
    parameter FIFO_SIZE = 32
) (
    input clk,

    input rst,

    output reg uart_tx = 1,

    input tx_enable,
    input [7:0] tx_byte,
    output [$clog2(FIFO_SIZE + 1) - 1:0] tx_count
);
  localparam DIVIDER = CLK / UART_BAUD;
  localparam BAUD_ACTUAL = CLK / DIVIDER;

  localparam STATE_IDLE = 0;
  localparam STATE_START = 1;
  localparam STATE_DATA = 2;
  localparam STATE_STOP = 3;

  // FIFO #(
  //     .SIZE(FIFO_SIZE)
  // ) tx_fifo (
  //     .clk(clk),
  //     .rst(rst),
  //     .push_enable(tx_enable),
  //     .push_byte(tx_byte),
  //     .pop_enable(),
  //     .pop_byte(),
  //     .count(tx_count)
  // );

  reg [ 1:0] state = STATE_IDLE;
  reg [ 2:0] data_counter = 0;
  reg [ 7:0] data = 0;

  reg [31:0] clk_counter = 0;

  always @(posedge clk) begin
    case (state)
      STATE_IDLE:  uart_tx <= 1;
      STATE_START: uart_tx <= 0;
      STATE_DATA:  uart_tx <= data[data_counter];
      STATE_STOP:  uart_tx <= 1;
    endcase

    if (rst) begin
      uart_tx <= 1;
      state <= STATE_IDLE;
      data_counter <= 0;
      data <= 0;
      clk_counter <= 0;
    end else if (state == STATE_IDLE) begin
      state <= STATE_START;
      clk_counter <= 0;
    end else if (clk_counter >= DIVIDER - 1) begin

      clk_counter <= 0;

      case (state)
        // STATE_IDLE: uart_tx <= 1;
        STATE_START: begin
          // uart_tx <= 0;
          state <= STATE_DATA;
          data_counter <= 0;
          data <= 8'd97;
        end
        STATE_DATA: begin
          if (data_counter == 7) state <= STATE_STOP;
          data_counter <= data_counter + 1;

          // uart_tx <= data[data_counter];
        end
        STATE_STOP: begin
          // uart_tx <= 1;
          state <= STATE_IDLE;
        end
      endcase
    end else clk_counter <= clk_counter + 1;
  end

endmodule

