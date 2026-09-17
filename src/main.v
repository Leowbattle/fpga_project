module blink (
    input clk,          // 27 MHz clock
    input key1,
    input key2,
    output led0,
    output led1,
    output led2,
    output led3,
    output led4,
    output led5
);
    reg rst = 1;

    blinking_led(.clk(clk), .rst(rst), .rst_brightness((256/5) * 0), .led(led0));
    blinking_led(.clk(clk), .rst(rst), .rst_brightness((256/5) * 1), .led(led1));
    blinking_led(.clk(clk), .rst(rst), .rst_brightness((256/5) * 2), .led(led2));
    blinking_led(.clk(clk), .rst(rst), .rst_brightness((256/5) * 3), .led(led3));
    blinking_led(.clk(clk), .rst(rst), .rst_brightness((256/5) * 4), .led(led4));
    blinking_led(.clk(clk), .rst(rst), .rst_brightness((256/5) * 5), .led(led5));
   
    always @(posedge clk) rst <= 0;
endmodule

module blinking_led(
    input clk,
    input rst,
    input[7:0] rst_brightness,
    output led
);
    reg[7:0] brightness = 0;
    led_pwm(.clk(clk), .brightness(brightness), .led(led));

    reg state = 0;

    localparam speed = 1024;
    localparam STEP_TICKS = 27_000_000 / speed;

    reg[31:0] counter = 0;
    always @(posedge clk) begin
        if (rst) brightness <= rst_brightness;
        else
        if (state == 0) begin
            if (brightness == 255) state <= 1;
            else if (counter == STEP_TICKS - 1) begin
                counter <= 0;
                brightness <= brightness + 1;
            end else
                counter <= counter + 1;
        end else begin
            if (brightness == 0) state <= 0;
            else if (counter == STEP_TICKS - 1) begin
                counter <= 0;
                brightness <= brightness - 1;
            end else
                counter <= counter + 1;
        end
    end
endmodule

//module blink (
//    input clk,          // 27 MHz clock
//    input key1,
//    input key2,
//    output led0,
//    output led1,
//    output led2,
//    output led3,
//    output led4,
//    output led5
//);
//    localparam CLK_FREQUENCY = 27_000_000;
//    localparam BLINK_FREQUENCY = 10;
//    localparam TRIGGER = (CLK_FREQUENCY - 1) / BLINK_FREQUENCY;

//    reg [24:0] counter = 0;

//    reg [5:0] leds = 6'b000000;
//    assign led0 = ~leds[0];
//    assign led1 = ~leds[1];
//    assign led2 = ~leds[2];
//    assign led3 = ~leds[3];
//    assign led4 = ~leds[4];
//    assign led5 = ~leds[5];

//    wire key1_pressed;
//    wire key2_pressed;
//    posedge_detector(
//        .clk(clk),
//        .signal(key1),
//        .out(key1_pressed));
//    posedge_detector(
//        .clk(clk),
//        .signal(key2),
//        .out(key2_pressed));

//    always @(posedge clk) begin
//        if (key1_pressed)leds <= leds + 1;
//        if (key2_pressed)leds <= leds - 1;
//    end
//endmodule
