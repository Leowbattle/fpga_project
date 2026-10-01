`timescale 1ns / 1ps
;

module main_tb;

  reg clk;

  wire led0;
  wire led1;
  wire led2;
  wire led3;
  wire led4;
  wire led5;

  reg key1 = 0;
  reg key2 = 0;

  wire uart_tx;

  reg enable;
  reg [7:0] tx_byte;
  wire stdin;
  wire tx_busy;
  uart_tx tx (
      .clk(clk),
      .rst(rst),
      .uart_tx(stdin),
      .tx_enable(enable),
      .tx_byte(tx_byte),
      .busy(tx_busy)
  );

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
      .uart_rx(stdin),
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
        "time=%0t clk=%d led0=%d led1=%d led2=%d led3=%d led4=%d led5=%d key1=%d key2=%d uart_tx=%d enable=%d tx_byte=%d stdin=%d tx_busy=%d",
        $time, clk, led0, led1, led2, led3, led4, led5, key1, key2, uart_tx, enable, tx_byte,
        stdin, tx_busy);

    enable  = 1;
    tx_byte = 8'h41;

    #23000 tx_byte = 8'h42;

    #23000 tx_byte = 8'h43;

    #23000 tx_byte = 8'h44;

    #23000 tx_byte = 8'h45;

    #100000 $finish;
  end
endmodule
