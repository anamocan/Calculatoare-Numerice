module reg19 (
    input  wire         clk,
    input  wire         rst,
    input  wire         en,
    input  wire         load,
  input  wire [18:0]  d,
  output wire [18:0]  q
);

  reg [18 : 0] test;
    genvar i;
    generate
      for (i = 0; i < 19; i = i + 1) begin : ff_array
            ffd u_ffd (
                .clk(clk),
                .rst(rst),
                .en(en & load),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

  assign test = q;
endmodule
