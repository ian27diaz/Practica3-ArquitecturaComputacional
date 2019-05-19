	/******************************************************************
* Description
*	This is control unit for the MIPS processor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corrponds to opcode from the instruction.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
module HazardDetectionUnit
(
    input ID_EX_MemRead,
    input [3:0]ID_EX_RegisterRt,
    input [3:0]IF_ID_RegisterRs,
    input [3:0]IF_ID_RegisterRt,
    output reg IF_ID_Write,
    output reg PC_Write,
    output reg control_mux
);
//Se pone 
always@(ID_EX_MemRead,ID_EX_RegisterRt,IF_ID_RegisterRs,IF_ID_RegisterRt) begin
        IF_ID_Write <= 1'b0;
        PC_Write <= 1'b0;
        control_mux <= 1'b0;
        
        if(ID_EX_MemRead && ((ID_EX_RegisterRt == IF_ID_RegisterRs) || (ID_EX_RegisterRt == IF_ID_RegisterRt)))
        begin
            IF_ID_Write <= 1'b1;
            PC_Write <= 1'b1;
            control_mux <= 1'b1;
        end

    end
	
endmodule
//control

