module rpn_calc #(
    parameter STACK_SIZE = 32
) (
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

  localparam STATE_0 = 0;
  localparam STATE_1 = 1;
  localparam STATE_2 = 2;

  reg [1:0] state = STATE_0;
  reg [7:0] operator = 0;

  // I would like 32 but the Tang Nano 20k only has 18 bit DSPs
  localparam WORD_SIZE = 16;
  reg [WORD_SIZE - 1:0] stack[STACK_SIZE:0];
  reg [7:0] sp = 0;  // TODO Size pointer correctly, check for stack overflow on push

  // TODO Handle negative numbers correctly
  // TODO Error on overflow

  // Used to hold number being converted from ASCII
  reg [WORD_SIZE - 1:0] num = 0;

  always @(posedge clk) begin
    if (rst) begin
      in_consumed <= 0;
      out_byte <= 0;
      out_ready <= 0;
      state <= STATE_0;
      operator <= 0;
      sp <= 0;
      num <= 0;
    end else if (out_ready && out_consumed) begin
      out_ready <= 0;
      out_byte  <= 0;
    end else if (in_available) begin
      if (in_byte == ASCII_LF) begin
        if (sp < 1) begin
          out_byte  <= ASCII_E;
          out_ready <= 1;
        end else begin
          // TODO Handle multi digit numbers
          out_byte <= stack[sp - 1] + ASCII_0;
          out_ready <= 1;
          sp <= sp - 1;
        end
      end else
        case (state)
          STATE_0: begin
            if (in_byte == ASCII_SPACE) begin  // Nothing
            end else if (in_byte >= ASCII_0 && in_byte <= ASCII_9) begin
              state <= STATE_1;
              num   <= in_byte - ASCII_0;
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
              stack[sp] <= num;
              sp <= sp + 1;
              num <= 0;
            end else if (in_byte >= ASCII_0 && in_byte <= ASCII_9) begin
              // state <= STATE_1;
              num <= num * 10 + in_byte - ASCII_0;
            end else begin
              out_byte <= ASCII_E;
              out_ready <= 1;
              state <= STATE_0;
            end
          end

          STATE_2: begin
            // The stack will probably be synthesised as a dual ported BRAM
            // so accessing two stack items at the same time is fine

            if (sp < 2) begin
              out_byte <= ASCII_E;
              out_ready <= 1;
              state <= STATE_0;
              sp <= 0;
            end else
              case (operator)
                ASCII_PLUS: begin
                  stack[sp-2] <= stack[sp-1] + stack[sp-2];
                  sp <= sp - 1;
                end
                ASCII_MINUS: begin
                  stack[sp-2] <= stack[sp-2] - stack[sp-1];
                  sp <= sp - 1;
                end
                ASCII_TIMES: begin
                  stack[sp-2] <= stack[sp-1] * stack[sp-2];
                  sp <= sp - 1;
                end
              endcase

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
