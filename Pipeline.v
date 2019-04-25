
//asereje

module Pipeline
#(
	parameter N = 32
)
(
	// Inputs
	input clk,
	input reset,
	input enable,
	input nopper,
	input		  [N-1:0] dataInput,
	output reg [N-1:0] dataOutput
);
always@(negedge reset or posedge clk or posedge nopper or posedge enable) begin // Para que escriba en flanco de subida
	if(reset==0 || nopper == 1)
		dataOutput <= 0;
	else	
		dataOutput <= dataInput;
end

endmodule