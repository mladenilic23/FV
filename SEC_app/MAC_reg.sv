module mac_imp #(parameter integer WIDTH = 8) (
    input logic clk,
    input logic rst, 
    input logic [WIDTH-1:0] a, b,
    //input logic [WIDTH-1:0] c,
    output logic [(2*WIDTH)-1:0] result
);

    logic [(2*WIDTH)-1:0] result_s;

    always_ff @(posedge clk) begin
        if (rst) begin
            result_s <= 0;
        end else begin
            result_s <= $signed(a) * $signed(b) + $signed(result_s);
        end
    end

    assign result = result_s;

endmodule
