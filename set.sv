module set(
  input wire clk,
  input wire rst,
  input wire en_change,
  input wire en_evict,
  input wire en_alloc,
  input wire en,
  input wire [18:0] tag,
  input wire en_check,
  output wire hit_out,
  output wire drty,
  output wire val
);

  wire [2:0] q_bar;
  wire [2:0] q;
  wire [3:0] valid;
  wire [3:0] dirty;
  wire [18:0] tag_outs [3:0];
  reg hit;

  // T Flip-Flops for victim selection
  t_flipflop first  (.clk(clk), .rst(rst), .en(en & en_alloc), .t(1'b1), .q(q[0]), .q_bar(q_bar[0]));
  t_flipflop second (.clk(clk), .rst(rst), .en(q_bar[0] & en & en_alloc), .t(1'b1), .q(q[1]), .q_bar(q_bar[1]));
  t_flipflop third  (.clk(clk), .rst(rst), .en(~q_bar[0] & en & en_alloc), .t(1'b1), .q(q[2]), .q_bar(q_bar[2]));

  // Cache blocks
  block blk1 (
    .clk(clk), .rst(rst), .en_change(en_change), .en_alloc(en_alloc),
    .tag(tag), .en(q_bar[0] & q_bar[1] & en & en_alloc),
    .dirty(dirty[0]), .valid(valid[0]), .tag_out(tag_outs[0])
  );

  block blk2 (
    .clk(clk), .rst(rst), .en_change(en_change), .en_alloc(en_alloc),
    .tag(tag), .en(q_bar[0] & ~q_bar[1] & en & en_alloc),
    .dirty(dirty[1]), .valid(valid[1]), .tag_out(tag_outs[1])
  );

  block blk3 (
    .clk(clk), .rst(rst), .en_change(en_change), .en_alloc(en_alloc),
    .tag(tag), .en(~q_bar[0] & q_bar[2] & en & en_alloc),
    .dirty(dirty[2]), .valid(valid[2]), .tag_out(tag_outs[2])
  );

  block blk4 (
    .clk(clk), .rst(rst), .en_change(en_change), .en_alloc(en_alloc),
    .tag(tag), .en(~q_bar[0] & ~q_bar[2] & en & en_alloc),
    .dirty(dirty[3]), .valid(valid[3]), .tag_out(tag_outs[3])
  );

  // HIT logic
  always @(*) begin
    if ((tag == tag_outs[0]) && valid[0]) hit = 1;
    else if ((tag == tag_outs[1]) && valid[1]) hit = 1;
    else if ((tag == tag_outs[2]) && valid[2]) hit = 1;
    else if ((tag == tag_outs[3]) && valid[3]) hit = 1;
    else hit = 0;
  end

  assign hit_out = hit & en_check;
  assign drty = dirty[0] | dirty[1] | dirty[2] | dirty[3];
  assign val = valid[0] | valid[1] | valid[2] | valid[3];

endmodule
