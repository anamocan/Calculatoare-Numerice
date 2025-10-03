module t_flipflop (
  input wire clk,
  input wire rst,
  input wire en,
  input wire t,
  output reg q,
  output wire q_bar
);

  always @(posedge clk) begin
    if (rst)
      q <= 0;
    else if (en && t)
      q <= ~q;
  end

  assign q_bar = ~q;

endmodule
