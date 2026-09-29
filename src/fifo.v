module FIFO #(
    parameter SIZE = 32
) (
    input clk,

    input rst,

    input push_enable,
    input [7:0] push_byte,

    input pop_enable,
    output reg [7:0] pop_byte,

    output reg [$clog2(SIZE + 1) - 1:0] count = 0
);
  reg [7:0] data[SIZE - 1:0];

  reg [$clog2(SIZE + 1) - 1:0] ptr_push = 0;
  reg [$clog2(SIZE + 1) - 1:0] ptr_pop = 0;

  always @(posedge clk) begin
    if (rst) begin
      ptr_push <= 0;
      ptr_pop  <= 0;
    end

    if (push_enable) begin
      data[ptr_push] <= push_byte;
      ptr_push <= (ptr_push + 1) % SIZE;
      if ((ptr_push + 1) % SIZE == ptr_pop) ptr_pop <= (ptr_pop + 1) % SIZE;
      
      // If full, overwrite beginning but don't increase size
      if (count < SIZE)
        count <= count + 1;
    end

    if (pop_enable && count > 0) begin
      ptr_pop <= (ptr_pop + 1) % SIZE;
      count <= count - 1;
    end

    pop_byte <= data[ptr_pop];
  end
endmodule
