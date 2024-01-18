module mac_spec#(parameter integer WIDTH = 8)(
    input logic clk,  
    input logic rst,    
    input logic [WIDTH-1:0] a, b, 
    //input logic [WIDTH-1:0] c,    
    output logic [(2*WIDTH)-1:0] result 
);

logic [(2*WIDTH)-1:0] mul_result; 
logic [(2*WIDTH)-1:0] add_result; 

// Perform multiplication of inputs a and b
always_ff @(posedge clk) begin
    if (rst) begin
        mul_result <= '0;
	add_result <= '0;
    end else begin
        mul_result <= $signed(a) * $signed(b);
        add_result <= $signed(mul_result) + $signed(add_result);  
    end
end

/* Perform addition with the accumulator
always_ff @(posedge clk) begin
    if (rst) begin
        add_result <= '0;
    end else begin
        add_result <= mul_result + c; 
    end
end
*/
// Assign the final result
assign result = add_result;

endmodule

