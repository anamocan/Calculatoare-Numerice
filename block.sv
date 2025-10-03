module block(
  input wire en,
  input wire en_change,
  input wire en_alloc,
  input wire [18:0]tag,
  input wire clk,
  input wire rst,
  output dirty,
  output valid,
  output [18:0]tag_out);
  
  ffd dir(.en(en&en_change), .clk(clk), .rst(rst), .q(dirty), .d(1'b1));
  ffd val(.en(en&en_alloc), .d(1'b1) , .clk(clk), .rst(rst), .q(valid));
  
  reg19 tg(.clk(clk), .rst(rst), .en(en), .load(en_alloc), .d(tag), .q(tag_out));
  
endmodule
  
  