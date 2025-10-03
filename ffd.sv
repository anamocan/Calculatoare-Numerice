module ffd (
    input  wire clk,       // Clock signal
    input  wire rst,       // Asynchronous reset
    input  wire en,        // Enable signal
    input  wire d,         // Data input
    output reg  q          // Data output
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else if (en)
            q <= d;
    end

endmodule
