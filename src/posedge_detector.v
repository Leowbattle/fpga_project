module posedge_detector (
    input  clk,
    input  signal,
    output out
);

  reg last_value = 0;

  assign out = signal & ~last_value;

  always @(posedge clk) begin
    last_value <= signal;
  end

endmodule
