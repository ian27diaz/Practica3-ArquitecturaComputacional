module ForwardUnit
(
	//inputs
	input clk,
	input EX_MEM_RegWrite,
	input [4:0] EX_MEM_RegisterRd,
	input [4:0] MEM_WB_RegisterRd,
	input [4:0] ID_EX_RegisterRs,
	input [4:0] ID_EX_RegisterRt,
	input MEM_WB_RegWrite,
	//outputs
	
	output reg [4:0] Forward_A,
	output reg [4:0] Forward_B

);

always@(negedge clk or EX_MEM_RegWrite, MEM_WB_RegWrite, EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt)
begin

	Forward_A <= 5'b00000;
	Forward_B <= 5'b00000;
	
	if((EX_MEM_RegWrite == 1) and (EX_MEM_RegisterRd != 0) and (EX_MEM_RegisterRd == ID_EX_RegisterRs) )
	begin
		Forward_A <= 5'00010;
	end
	
	if((EX_MEM_RegWrite == 1) and (EX_MEM_RegisterRd != 0) and (EX_MEM_RegisterRd == ID_EX_RegisterRt))
	begin
		Forward_B <= 5'b00010;
	end
	
	if((EX_MEM_RegWrite == 1) and (EX_MEM_RegisterRd != 0) and (EX_MEM_RegisterRd == ID_EX_RegisterRs) and (EX_MEM_RegisterRd != ID_EX_RegisterRs))
	begin
		Forward_A <= 5'00001;
	end
	
	if((EX_MEM_RegWrite == 1) and (EX_MEM_RegisterRd != 0) and (EX_MEM_RegisterRd == ID_EX_RegisterRt) and (EX_MEM_RegisterRd != ID_EX_RegisterRt))
	begin
		Forward_B <= 5'b00001;
	end

end


endmodule




