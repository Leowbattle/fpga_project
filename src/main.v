module blink (
    input  clk,   // 27 MHz clock
    input  key1,
    input  key2,
    output led0,
    output led1,
    output led2,
    output led3,
    output led4,
    output led5,

    input uart_rx,
    output uart_tx,

    output reg gpio
);

  assign led0 = uart_rx;

  assign uart_tx = 1'b1;

  // Turn off the remaining LEDs to reduce clutter (Onboard LEDs are Active-Low)
  assign led1 = 1'b1;
  assign led2 = 1'b1;
  assign led3 = 1'b1;
  assign led4 = 1'b1;
  assign led5 = 1'b1;

  reg[31:0] counter = 0;
  initial gpio = 0;

  always @(posedge clk) begin
    counter <= counter + 1;

    if (counter >= 27_000_000 / 2) begin
      counter <= 0;
      gpio <= ~gpio;
    end
  end

endmodule
