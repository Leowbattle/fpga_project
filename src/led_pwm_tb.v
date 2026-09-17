`timescale 1ns/1ps;

module led_pwm_tb;
    reg clk;
    wire led;
    wire led1;
    wire led2;

    reg[7:0] brightness = 8'd0;
    led_pwm dut(
        .clk(clk),
        .brightness(brightness),
        .led(led));

    reg[7:0] brightness1 = 8'd1;
    led_pwm dut1(
        .clk(clk),
        .brightness(brightness1),
        .led(led1));

    reg[7:0] brightness2 = 8'd255;
    led_pwm dut2(
        .clk(clk),
        .brightness(brightness2),
        .led(led2));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("led_pwm.vcd");
        $dumpvars(0, led_pwm_tb);
    end

    initial begin
        $monitor("time=%0t clk=%d brightness=%d =%d =%d =%d",
                 $time, clk, brightness, led, led1, led2);

        #2560
        #2560

        $finish;
    end
endmodule