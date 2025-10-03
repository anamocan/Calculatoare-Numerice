module cache_controller (
    input wire clk,
    input wire rst,
    input wire [31:0] addr,
    input wire read,
    input wire write,
    output wire ready
);

    wire [6:0] index;         // 128 sets → 7-bit index
    wire [18:0] tag;          // 19-bit tag

    assign index = addr[13:7];     // 7-bit index
    assign tag   = addr[31:13];    // 19-bit tag

    wire [127:0] set_select;
    assign set_select = 128'b1 << index;

    wire [127:0] hit_outs;
    wire [127:0] drty_outs;
    wire [127:0] val_outs;

    wire hit, dirty, valid;
    wire [6:0] i = index;

    assign hit   = hit_outs[i];
    assign dirty = drty_outs[i];
    assign valid = val_outs[i];

    wire check, alloc, change, lru, rdy;
    reg v, h, miss;

    always @(*) begin
        v    = read | write;
        h    = hit;
        miss = ~hit;
    end

    // 128 instanțe de set, conectate la adresa corespunzătoare
    set cache_sets [127:0] (
        .clk(clk),
        .rst(rst),
        .en_change({128{change}} & set_select),
        .en_evict({128{lru}} & set_select),
        .en_alloc({128{alloc}} & set_select),
        .en({128{1'b1}}),
        .tag({128{tag}}),
        .en_check({128{check}} & set_select),
        .hit_out(hit_outs),
        .drty(drty_outs),
        .val(val_outs)
    );

    // FSM de control
    fsm control_unit (
        .clk(clk),
        .rst(rst),
        .v(v),
        .hit(h),
        .write(write),
        .read(read),
        .miss(miss),
        .dirty(dirty),
        .valid(valid),
        .rdy(rdy),
        .lru(lru),
        .change(change),
        .check(check),
        .alloc(alloc)
    );

    assign ready = rdy;

endmodule

