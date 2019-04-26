/******************************************************************
* Description
*	This is the top-level of a MIPS processor
* This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor w-as made for computer organization class at ITESO.
******************************************************************/



module MIPS_Processor
#(
	parameter MEMORY_DEPTH = 64
)

(
	// Inputs
	input clk,
	input reset,
	input [7:0] PortIn,
	// Output
	output [31:0] ALUResultOut,
	output [31:0] PortOut
);
//******************************************************************/
//******************************************************************/
assign PortOut = 0;

//******************************************************************/
//******************************************************************/
// Data types to connect modules
wire BranchNE_wire;
wire BranchEQ_wire;
wire RegDst_wire;
wire NotZeroANDBrachNE;  						
wire ZeroANDBrachEQ;							
wire ORForBranch;									
wire ALUSrc_wire;
wire RegWrite_wire;
wire Zero_wire;
wire [3:0] ALUOp_wire;
wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;//salida del primer mux
wire [31:0] MUX_PC_wire;					
wire [31:0] PC_wire;
wire [31:0] Instruction_wire;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData2_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
wire [31:0] InmmediateExtendAnded_wire; 	
wire [31:0] PCtoBranch_wire;	
integer ALUStatus;
//Wires añadidos
wire PCSrc;
wire [31:0] InmmediateExtend_SL2_wire;
  
wire [31:0] ramDataWire;
wire MemtoRegWire;
wire [31:0]MuxALUsrcORRamDataWire;
wire [31:0]salidaMuxALUsrc;
wire MemReadWire;
wire MemWriteWire;

wire [31:0] jumpAddress;
wire [31:0] jumpAddressAux;
wire [31:0] Super_MUX_PC_wire;	
wire jump_wire;

wire jal_wire;
wire [4:0] WriteRegisterAux_wire;
wire [31:0] ALUResult_Or_PC_4;

wire jr_wire;

wire [31:0] Final_MUX_PC_wire;

/***************** WIRES para el pipeline **************************/
//wires para IF/ID
wire [31:0] ID_instruction_wire;
wire [31:0] ID_PC_4_wire;

//Wires para ID/EX
wire EX_RegDst_wire;
wire EX_BranchNE_wire;
wire EX_MemReadWire;
wire EX_BranchEQ_wire;
wire EX_MemWriteWire;
wire EX_MemtoRegWire;
wire [3:0] EX_ALUOp_wire;
wire EX_ALUSrc_wire;
wire EX_RegWrite_wire;
wire EX_jump_wire;
wire EX_jal_wire;
wire [31:0] EX_PC_4_wire;
wire [31:0] EX_ReadData1_wire;
wire [31:0] EX_ReadData2_wire;
wire [31:0] EX_InmmediateExtend_wire;
wire [31:0] EX_instruction_wire;

//wires para EX/MEM
wire [31:0] MEM_InmmediateExtendAnded_wire;
wire [31:0] MEM_ALUResult_wire;
wire [31:0] MEM_ReadData2_wire;
wire [4:0] MEM_WriteRegister_wire;
wire [31:0] MEM_MUX_PC_wire;
wire MEM_MemReadWire;
wire MEM_MemWriteWire;
wire MEM_MemtoRegWire;
wire MEM_RegWrite_wire;
wire MEM_jal_wire;

//wires para MEM/WB
wire [31:0] WB_ramDataWire;
wire [31:0] WB_ALUResult_wire;
wire [4:0] WB_WriteRegister_wire;
wire WB_MemWriteWire;
wire WB_MemtoRegWire;
wire WB_RegWrite_wire;
wire WB_jal_wire;
wire [31:0] WB_MUX_PC_wire;
//******************************************************************/
//******************************************************************/
//******************************************************************/

//Pipeline IF/ID
Pipeline
#(
	.N(64)
)
Pipeline_IF_ID 
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.nopper(1'b0),
	.dataInput({Instruction_wire, PC_4_wire}),
	.dataOutput({ID_instruction_wire, ID_PC_4_wire})
);
	
Pipeline
#(
	.N(174)
)
Pipeline_ID_EX
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.nopper(1'b0),
	.dataInput({RegDst_wire,
					BranchNE_wire,
					MemReadWire,
					BranchEQ_wire,
					MemWriteWire,
					MemtoRegWire,
					ALUOp_wire,
					ALUSrc_wire,
					RegWrite_wire,
					jump_wire,
					jal_wire,
					ID_PC_4_wire,
					ReadData1_wire,
					ReadData2_wire,
					InmmediateExtend_wire,
					ID_instruction_wire
					}),
	.dataOutput({EX_RegDst_wire,
					 EX_BranchNE_wire,
					 EX_MemReadWire,
					 EX_BranchEQ_wire,
					 EX_MemWriteWire,
					 EX_MemtoRegWire,
					 EX_ALUOp_wire,
					 EX_ALUSrc_wire, //
					 EX_RegWrite_wire,
					 EX_jump_wire,
					 EX_jal_wire,
					 EX_PC_4_wire,
					 EX_ReadData1_wire,
					 EX_ReadData2_wire,
					 EX_InmmediateExtend_wire,
					 EX_instruction_wire
					 })
);


Pipeline
#(
	.N(137)
)
Pipeline_EX_MEM
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.nopper(1'b0),
	.dataInput({
				InmmediateExtendAnded_wire,
				ALUResult_wire,
				EX_ReadData2_wire,
				WriteRegister_wire,
				MUX_PC_wire,
				EX_MemReadWire,
				EX_MemWriteWire,
				EX_MemtoRegWire,
				EX_RegWrite_wire,
				EX_jal_wire
				}),
	.dataOutput({
				MEM_InmmediateExtendAnded_wire,
				MEM_ALUResult_wire,
				MEM_ReadData2_wire,
				MEM_WriteRegister_wire,
				MEM_MUX_PC_wire,
				MEM_MemReadWire,
				MEM_MemWriteWire,
				MEM_MemtoRegWire,
				MEM_RegWrite_wire,
				MEM_jal_wire})
);

//Pipeline MEM/WB
Pipeline
#(
	.N(105)
)
Pipeline_MEM_WB 
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.nopper(1'b0),
	.dataInput({
				ramDataWire,
				MEM_ALUResult_wire,
				MEM_MemWriteWire,
				MEM_MemtoRegWire,
				MEM_RegWrite_wire,
				MEM_jal_wire,
				MEM_WriteRegister_wire,
				MEM_MUX_PC_wire ////////////////////
				}),
	.dataOutput({
				WB_ramDataWire,
				WB_ALUResult_wire,
				WB_MemWriteWire,
				WB_MemtoRegWire,
				WB_RegWrite_wire,
				WB_jal_wire,
				WB_WriteRegister_wire,
				WB_MUX_PC_wire})
);

//******************************************************************/
//******************************************************************/
//******************************************************************/

Control
ControlUnit
(
	.OP(ID_instruction_wire[31:26]),
	.RegDst(RegDst_wire),
	.BranchNE(BranchNE_wire), //
	.MemRead(MemReadWire),
	.BranchEQ(BranchEQ_wire), //
	.MemWrite(MemWriteWire),
	.MemtoReg(MemtoRegWire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),	
	.RegWrite(RegWrite_wire),
	.Jump(jump_wire), //
	.Jal(jal_wire) //
);

//Implementación de la RAM

DataMemory 
#(	
	.DATA_WIDTH(),
	.MEMORY_DEPTH()

)
RamMemory
(
	.WriteData(MEM_ReadData2_wire),
	.Address(MEM_ALUResult_wire),
	.MemWrite(MEM_MemWriteWire),
	.MemRead(MEM_MemReadWire),
	.clk(clk),
	//salidas
	.ReadData(ramDataWire)
);


//Implementación de la RAM FIN

PC_Register
#(
 .N(32)
)
PC_Register_b
(
	.clk(clk),
	.reset(reset),
	.NewPC(Final_MUX_PC_wire),
	.PCValue(PC_wire)
);

ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
ROMProgramMemory
(
	.Address(PC_wire),
	.Instruction(Instruction_wire)
);

Adder32bits
PC_Puls_4
(
	.Data0(PC_wire),
	.Data1(4),
	
	.Result(PC_4_wire)
);



//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType //MUX para elegir en que 
(	//registro guardar, toma en cuenta si es I o R
	.Selector(EX_RegDst_wire),
	.MUX_Data0(EX_instruction_wire[20:16]),
	.MUX_Data1(EX_instruction_wire[15:11]),
	
	.MUX_Output(WriteRegisterAux_wire)

);

//JAL
Multiplexer2to1
#(
	.NBits(5)
)
Mux_ForJalOrWriteRegisterAux //MUX para elegir el 
(	//camino normal o en caso de ser jal, escribir en RA
	.Selector(EX_jal_wire),
	.MUX_Data0(WriteRegisterAux_wire),
	.MUX_Data1(5'b11111),
	
	.MUX_Output(WriteRegister_wire)

);

Multiplexer2to1 //Mux de hasta la derecha del diagrama.
#(
	.NBits()
)
MuxALUsrcORRamData 
(
	.Selector(WB_MemtoRegWire),
	.MUX_Data0(WB_ALUResult_wire),
	.MUX_Data1(WB_ramDataWire),
	
	.MUX_Output(MuxALUsrcORRamDataWire)

);

//Multiplexer for PCPlus4OrALUResult, PARA JAL TAMBIEN
Multiplexer2to1 //Este mux decide si mandar lo del MUX 
#(	// de hasta la derecha O el PC_4wire, en caso de ser jal, para escribir en RA el PC_4_Wire
	.NBits(32)
)
Mux_ForAluResult_Or_PC_plus_4 
(
	.Selector(WB_jal_wire),
	.MUX_Data0(MuxALUsrcORRamDataWire),
	.MUX_Data1(EX_PC_4_wire), //Se cambiara??
	
  .MUX_Output(ALUResult_Or_PC_4) ////////////////////////////////////////////////////////////

);



RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(WB_RegWrite_wire), ///////////////CORREGIR
	.WriteRegister(WB_WriteRegister_wire),
	.ReadRegister1(ID_instruction_wire[25:21]),
	.ReadRegister2(ID_instruction_wire[20:16]),
	.WriteData(ALUResult_Or_PC_4), //Si es JAl, sera PC_4
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(ID_instruction_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
);



Multiplexer2to1 //Este es el mux entre la ALU y el Register Files
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(EX_ALUSrc_wire),
	.MUX_Data0(EX_ReadData2_wire),
	.MUX_Data1(EX_InmmediateExtend_wire), //
	
	.MUX_Output(salidaMuxALUsrc)

);


ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(EX_ALUOp_wire),
	.ALUFunction(EX_instruction_wire[5:0]),
	.ALUOperation(ALUOperation_wire)
);



ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.rs(EX_ReadData2_wire),
	.A(EX_ReadData1_wire),
	.B(salidaMuxALUsrc), //Si es immediate o lo de Register File
	.shamt(EX_instruction_wire[10:6]),
	.Zero(Zero_wire),
	.isJR(jr_wire), //Como JR es tipo R, aqui decido el cable jr.
	.ALUResult(ALUResult_wire)
);

/******* Logica para los cables branches ***********/
ANDGate
ZeroAndBranchEQ_AND
(
	.A(EX_BranchEQ_wire),
	.B(Zero_wire),
	.C(ZeroANDBrachEQ)
);


ANDGate
NotZeroAndBranchNE_AND
(
	.A(EX_BranchNE_wire),
	.B(~Zero_wire),
	.C(NotZeroANDBrachNE)
);

ORGate
ORGate_BranchNE_BranchEQ
(
	.A(ZeroANDBrachEQ),
	.B(NotZeroANDBrachNE),
	.C(PCSrc)
);
/****************************************************/

ShiftLeft2 //Este dato es el que es la direccion de branch
SL2_SignExtend
(
	.DataInput(EX_InmmediateExtend_wire),
	.DataOutput(InmmediateExtend_SL2_wire)
);

Adder32bits //Este es el adder del PC_4_Wire y el dato inmediato<<2
PC4_Immediate
(
	.Data0(EX_PC_4_wire),
	.Data1(InmmediateExtend_SL2_wire),
	.Result(InmmediateExtendAnded_wire)
);

Multiplexer2to1 //Este multiplexor es el que decide si mandar branchAddr o el PC_4_Wire, debe ser el primer mux
#(
	.NBits(32)
)
Mux_PC4Wire_ImmediateExtendedAndedWire
(
	.Selector(PCSrc),
	.MUX_Data0(EX_PC_4_wire),
	.MUX_Data1(InmmediateExtendAnded_wire),
	
	.MUX_Output(MUX_PC_wire) // ************ ex-mem

);


//FOR JUMP INSTRUCTION
ShiftLeft2 //Logica para la JumpAddr
J_Address_SL2
(
	.DataInput({6'b0, ID_instruction_wire[25:0]}),
	.DataOutput(jumpAddressAux)
);

Adder32bits //Logica para la JumpAddr
Address_plus_PC4Wire
(
	.Data0({PC_4_wire[31:28], 28'b0}),
	.Data1(jumpAddressAux),
	.Result(jumpAddress)
);


Multiplexer2to1 //Este es el segundo mux del PC, decide si mandar lo de BranchAddr/Pc_4_wire o la jumpAddr
#(
	.NBits(32)
)
MUX_MuxPCWire_JumpAddress
(
	.Selector(jump_wire),
	.MUX_Data0(MUX_PC_wire),
	.MUX_Data1(jumpAddress - 4194304),
	
	.MUX_Output(Super_MUX_PC_wire)

);

Multiplexer2to1 //Este mux pretende escribir entre 
#(	//(BranchAddr/Pc_4_wire)/jumpAddr o el AluResult, que deberia 
	.NBits(32)	//de ser lo que esta guardado en RA, que es el PC que se almacenó en el JAL
)
MUX_SuperMUXPC_JR_PC8
(
	.Selector(jr_wire), //////////// PROB SE OCUPE PASAR AL PIPELINE EX/MEM
	.MUX_Data0(Super_MUX_PC_wire),
	.MUX_Data1(MuxALUsrcORRamDataWire), //hardcoded, probably wrong but it works
	
	.MUX_Output(Final_MUX_PC_wire)

);

assign ALUResultOut = ALUResult_wire;

endmodule

