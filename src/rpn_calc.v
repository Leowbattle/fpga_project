module rpn_calc (
    input clk,

    input rst,

    input [7:0] in_byte,
    input in_available,
    output reg in_consumed = 0,

    output reg [7:0] out_byte = 0,
    output reg out_ready = 0,
    input out_consumed
);
  localparam ASCII_SPACE = 8'd32;
  localparam ASCII_PLUS = 8'd43;
  localparam ASCII_MINUS = 8'd45;
  localparam ASCII_TIMES = 8'd42;
  // localparam ASCII_DIVIDE = 8'd47;
  localparam ASCII_0 = 8'd48;
  localparam ASCII_9 = 8'd57;
  localparam ASCII_LF = 8'd10;

  // Used to indicate error
  localparam ASCII_E = 8'd69;

  // Placeholder for numerical output
  localparam ASCII_N = 8'd78;

  localparam STATE_0 = 0;
  localparam STATE_1 = 1;
  localparam STATE_2 = 2;

  reg [1:0] state = STATE_0;

  reg [7:0] operator = 0;

  always @(posedge clk) begin
    if (rst) begin
      in_consumed <= 0;
      out_byte <= 0;
      out_ready <= 0;
      state <= STATE_0;
      operator <= 0;
    end else if (out_ready && out_consumed) begin
      out_ready <= 0;
      out_byte  <= 0;
    end else if (in_available) begin
      if (in_byte == ASCII_LF) begin
        out_byte <= ASCII_N;
        out_ready <= 1;
      end else
        case (state)
          STATE_0: begin
            if (in_byte == ASCII_SPACE) begin  // Nothing
            end else if (in_byte >= ASCII_0 && in_byte <= ASCII_9) begin
              state <= STATE_1;
            end
            else if (in_byte == ASCII_PLUS || in_byte == ASCII_MINUS || in_byte == ASCII_TIMES) begin
              state <= STATE_2;
              operator <= in_byte;
            end else begin
              out_byte  <= ASCII_E;
              out_ready <= 1;
              // state <= STATE_0;
            end
          end

          STATE_1: begin
            if (in_byte == ASCII_SPACE) begin
              state <= STATE_0;
            end else if (in_byte >= ASCII_0 && in_byte <= ASCII_9) begin
              // state <= STATE_1;
            end else begin
              out_byte <= ASCII_E;
              out_ready <= 1;
              state <= STATE_0;
            end
          end

          STATE_2: begin
            if (in_byte == ASCII_SPACE) begin
              state <= STATE_0;
            end else begin
              out_byte <= ASCII_E;
              out_ready <= 1;
              state <= STATE_0;
            end
          end

        endcase

      in_consumed <= 1;
    end
  end

endmodule
