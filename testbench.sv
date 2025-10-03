`timescale 1ns / 1ps

module testbench;

  reg clk = 0;
  reg rst = 1;
  reg [31:0] addr;
  reg read;
  reg write;

  wire ready;
  wire [2:0] fsm_state;

  cache_controller cache (
    .clk(clk),
    .rst(rst),
    .addr(addr),
    .read(read),
    .write(write),
    .ready(ready)
  );

  assign fsm_state = cache.control_unit.st;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
    addr = 0;
    read = 0;
    write = 0;

    #10 clk = 1; #10 clk = 0;
    rst = 0;

    addr = 32'h00000010; read = 1;
    #10 clk = 1; #10 clk = 0;
    read = 0;

    addr = 32'h00000020; write = 1;
    #10 clk = 1; #10 clk = 0;
    write = 0;

    addr = 32'h00000100; read = 1;
    #10 clk = 1; #10 clk = 0;
    read = 0;

    addr = 32'h00000200; write = 1;
    #10 clk = 1; #10 clk = 0;
    write = 0;

    addr = 32'h00000010; read = 1;
    #10 clk = 1; #10 clk = 0;
    read = 0;

    addr = 32'h00000020; read = 1;
    #10 clk = 1; #10 clk = 0;
    read = 0;

    #20 $finish;
  end

  always @(posedge clk) begin
    $display("T=%0t | FSM=%0d | Addr=%h | R=%b W=%b | Ready=%b",
             $time, fsm_state, addr, read, write, ready);
  end

endmodule
