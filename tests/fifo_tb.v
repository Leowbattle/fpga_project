`timescale 1ns / 1ps

module fifo_tb;

  reg clk;

  reg rst = 0;

  reg push_enable = 0;
  reg [7:0] push_byte = 0;

  reg pop_enable = 0;
  wire [7:0] pop_byte;

  wire [5:0] count;

  FIFO #(
      .SIZE(32)
  ) dut (
      .clk(clk),
      .rst(rst),
      .push_enable(push_enable),
      .push_byte(push_byte),
      .pop_enable(pop_enable),
      .pop_byte(pop_byte),
      .count(count)
  );

  // 10 ns clock period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("fifo.vcd");
    $dumpvars(0, fifo_tb);
  end

  initial begin
    $monitor(
        "time=%0t clk=%d rst=%d push_enable=%d push_byte=%d pop_enable=%d pop_byte=%d count=%d ptr_push=%d ptr_pop=%d",
        $time, clk, rst, push_enable, push_byte, pop_enable, pop_byte, count, dut.ptr_push,
        dut.ptr_pop);

    rst = 1;
    #10;

    rst = 0;

    push_enable = 1;
    push_byte = 8'd123;
    #10;

    push_enable = 1;
    push_byte   = 8'd42;
    #10;

    push_enable = 1;
    pop_enable  = 1;
    push_byte   = 8'd55;

    #10;

    push_enable = 0;

    #30;

    pop_enable = 0;

    for (integer i = 0; i < 40; i = i + 1) begin
      push_enable = 1;
      push_byte   = i;

      #10;
    end

    push_enable = 0;
    pop_enable  = 1;

    for (integer i = 0; i < 32; i = i + 1) begin
      #10;
    end

    pop_enable = 0;

    #10 $finish;
  end

endmodule
