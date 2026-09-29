`timescale 1ns / 1ps
;

module uart_tb;

  reg clk;
  reg rst = 0;
  wire uart_tx;
  reg tx_enable;
  reg [7:0] tx_byte;
  wire [7:0] tx_count;

  uart_tx #(
      .CLK(100_000_000),
      .UART_BAUD(115200),
      .FIFO_SIZE(32)
  ) dut (
      .clk(clk),
      .rst(rst),
      .uart_tx(uart_tx),
      .tx_enable(tx_enable),
      .tx_byte(tx_byte),
      .tx_count(tx_count)
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
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);
  end

  initial begin
    $monitor("time=%0t clk=%d rst=%d uart_tx=%d state=%d data_counter=%d data=%d clk_counter=%d",
             $time, clk, rst, uart_tx, dut.state, dut.data_counter, dut.data, dut.clk_counter);

    rst = 1;
    #10;

    rst = 0;

    tx_enable = 1;
    tx_byte = 8'd97;

    #10;

    tx_byte = 8'd98;

    #10;

    tx_byte = 8'd99;

    #10 tx_enable = 0;

    #300000 $finish;
  end
endmodule
