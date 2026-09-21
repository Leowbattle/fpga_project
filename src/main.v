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
    output reg uart_tx
);

  assign led0 = ~(state == STATE_IDLE);
  assign led1 = ~(state == STATE_START);
  assign led2 = ~(state == STATE_DATA);
  assign led3 = ~(state == STATE_STOP);

  // 1.02% error
  localparam CLK = 27_000_000;
  localparam UART_BAUD = 2000000;
  localparam OVERSAMPLE = 1;

  localparam DIVIDER = CLK / (OVERSAMPLE * UART_BAUD);
  localparam BAUD_ACTUAL = CLK / (OVERSAMPLE * DIVIDER);

  // ASCII 'a'
  localparam DATA = 8'b01100001;
  // localparam DATA = "a";

  localparam STATE_IDLE = 0;
  localparam STATE_START = 1;
  localparam STATE_DATA = 2;
  localparam STATE_STOP = 3;

  initial begin
    $display("CLK = %0d", CLK);
    $display("UART_BAUD = %0d", UART_BAUD);
    $display("OVERSAMPLE = %0d", OVERSAMPLE);
    $display("DIVIDER = %0d", DIVIDER);
    $display("BAUD_ACTUAL = %0d", BAUD_ACTUAL);
    
    // $display("Error = %f", (BAUD_ACTUAL - real'(UART_BAUD)) / UART_BAUD * 100.0);
  end

  reg[1:0] state = STATE_IDLE;
  reg[2:0] data_counter;
  reg[7:0] data;
  
  reg[31:0] clk_counter = 0;

  always @(posedge clk) begin
    if (state == STATE_IDLE && key1) begin
      state <= STATE_START;
    end

    if (clk_counter >= DIVIDER) begin
      clk_counter <= 0;

      case (state)
        STATE_IDLE: uart_tx <= 1;
        STATE_START: begin
          uart_tx <= 0;
          state <= STATE_DATA;
          data_counter <= 0;
          data <= DATA;
        end
        STATE_DATA: begin
          if (data_counter == 7) state <= STATE_STOP;
          data_counter <= data_counter + 1;

          uart_tx <= data[data_counter];
        end
        STATE_STOP: begin
          uart_tx <= 1;
          state <= STATE_IDLE;
        end
      endcase
    end else
      clk_counter <= clk_counter + 1;
  end
endmodule
