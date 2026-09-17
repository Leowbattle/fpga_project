module edge_detector(
    input clk,
    input signal,
    output out
);

    reg last_value = 0;

    assign out = last_value != signal;

    always @(posedge clk) begin
        last_value <= signal;
    end

endmodule