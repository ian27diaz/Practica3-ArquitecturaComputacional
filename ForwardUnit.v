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
	
	output reg [1:0] Forward_A,
	output reg [1:0] Forward_B

);

always@(EX_MEM_RegWrite, MEM_WB_RegWrite, EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt)
begin
	Forward_A <= 2'b00;
	Forward_B <= 2'b00;
	
	if((EX_MEM_RegWrite == 1) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs) )
	begin
		Forward_A <= 2'b10;
	end
	
	if((EX_MEM_RegWrite == 1) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRt))
	begin
		Forward_B <= 2'b10;
	end
	
	if((EX_MEM_RegWrite == 1) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs) && (EX_MEM_RegisterRd != ID_EX_RegisterRs))
	begin
		Forward_A <= 2'b01;
	end
	
	if((EX_MEM_RegWrite == 1) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRt) && (EX_MEM_RegisterRd != ID_EX_RegisterRt))
	begin
		Forward_B <= 2'b01;
	end

end


endmodule




