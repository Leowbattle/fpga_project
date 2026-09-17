`timescale 1ns/1ps

module edge_detector_tb;

    reg clk;
    reg signal;
    wire out;

    edge_detector dut(
        .clk(clk),
        .signal(signal),
        .out(out)
    );

    // 10 ns clock period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("edge_detector.vcd");
        $dumpvars(0, edge_detector_tb);
    end

    initial begin
        $monitor("time=%0t clk=%d signal=%b =%d",
                 $time, clk, signal, out);

        signal = 0;

        #10

        signal = 1;

        #10

        signal = 0;

        #20

        signal = 1;

        #10

        $finish;
    end

endmodule