module fsm
  (
    input clk, rst,
    input v, hit, write, read, miss, dirty, valid,
    output reg rdy, lru, change, check, alloc
  );
  
  localparam IDLE = 3'd0;
  localparam CHECK = 3'd1;
  localparam WRITE_HIT = 3'd2;
  localparam READ_HIT = 3'd3;
  localparam READ_MISS = 3'd4;
  localparam WRITE_MISS = 3'd5;
  localparam EVICT = 3'd6;
  localparam ALLOC = 3'd7;
  reg[2:0] st;
  reg[2:0] st_nxt;
  
  always@(*)
    case(st)
      IDLE: if(!v) st_nxt = IDLE;
      else if (v) st_nxt = CHECK;
      CHECK: if(hit & write) st_nxt = WRITE_HIT;
      else if (hit & read) st_nxt = READ_HIT;
      else if (miss & write) st_nxt = WRITE_MISS;
      else if (miss & read) st_nxt = READ_MISS;
      WRITE_HIT: if(rdy) st_nxt = IDLE;
      READ_HIT: if(rdy) st_nxt = IDLE;
      READ_MISS: if(valid & dirty) st_nxt = EVICT;
      else if(!valid * !dirty) st_nxt = ALLOC;
      WRITE_MISS: if(valid & dirty) st_nxt = EVICT;
      else if(!valid * !dirty) st_nxt = ALLOC;
      EVICT: st_nxt = ALLOC;
      ALLOC: if(rdy) st_nxt = IDLE;
    endcase
  
  always@(*) begin
    rdy = 1'd0;
    lru = 1'd0;
    change = 1'd0;
    check = 1'd0;
    alloc = 1'd0;
    case(st)
      IDLE: if(valid) {check,rdy} = 1'd1;
      CHECK: if(hit&write) check = 1'd1;
      else if (hit&read) rdy = 1'd1;
      else if (read&miss) {lru, change} = 1'd1;
      else if (write&miss) {lru, change} = 1'd1;
      WRITE_HIT: rdy = 1'b1;
      READ_HIT : rdy = 1'b1;
      READ_MISS : if(valid & dirty)lru = 0;
      else if ( !valid*!dirty) alloc = 1'd1;
      WRITE_MISS: if(valid & dirty) {lru, change} = 1'd1;
      else if (!valid * !dirty) change = 1'd1;
      ALLOC: rdy = 1'd1;
    endcase
  end
  
  always@(posedge clk or posedge rst)
    if(rst) begin 
      st<=IDLE;
      st_nxt = IDLE;
    end
  	else st<= st_nxt;
endmodule
        
        
        
        
        
 