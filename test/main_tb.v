`timescale 1ns / 1ps
;

module main_tb;

  reg  clk;

  wire led0;
  wire led1;
  wire led2;
  wire led3;
  wire led4;
  wire led5;

  reg  key1 = 0;
  reg  key2 = 0;

  reg  uart_rx = 0;
  wire uart_tx;

  main dut (
      .clk(clk),
      .led0(led0),
      .led1(led1),
      .led2(led2),
      .led3(led3),
      .led4(led4),
      .led5(led5),
      .key1(key1),
      .key2(key2),
      .uart_rx(uart_rx),
      .uart_tx(uart_tx)
  );

  // 10 ns clock period
  initial begin
    clk = 0;
    forever begin
      #5 clk = ~clk;
      #5 clk = ~clk;
    end
  end

  initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main_tb);
  end

  initial begin
    $monitor(
        "time=%0t clk=%d led0=%d led1=%d led2=%d led3=%d led4=%d led5=%d key1=%d key2=%d uart_rx=%d uart_tx=%d",
        $time, clk, led0, led1, led2, led3, led4, led5, key1, key2, uart_rx, uart_tx);

    key2 = 1;
    #10;
    key2 = 0;
    key1 = 1;

    #100000 $finish;
  end
endmodule
