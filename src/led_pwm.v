module led_pwm (
    input clk,
    input [7:0] brightness,
    output led
);

  reg [7:0] counter = 8'd0;

  assign led = (brightness == 8'd255) ? 1'b0 : ~(counter < brightness);

  always @(posedge clk) begin
    counter <= counter + 1'b1;
  end

endmodule
