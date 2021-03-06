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
wire [31:0] MEM_instruction_wire;
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
wire [31:0] WB_instruction_wire;

//Wires para ForwardUnit
wire [1:0] forwardA;
wire [1:0] forwardB;

wire [31:0] mux3to1_a_output;
wire [31:0] mux3to1_b_output;

//wires para HazardDetectionUnit
wire IF_ID_Write;
wire control_mux_wire;
wire pc_write;
wire [13:0] Mux_Control_or_Flush;
wire [31:0] PC_flushed_or_PC4Wire;

//******************************************************************/
//******************************************************************/
//******************************************************************/

//Pipeline IF/ID
Pipeline
#(
	.N(64)
)
Pipeline_IF_ID //Correcto al parecer
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.nopper(IF_ID_Write),
	.dataInput({Instruction_wire, PC_4_wire}),
	.dataOutput({ID_instruction_wire, ID_PC_4_wire})
);

//************************HAZARD DET. UNIT*********************************/
HazardDetectionUnit
hazardDetUnit
(
	.ID_EX_MemRead(EX_MemReadWire),
    .ID_EX_RegisterRt(EX_instruction_wire[20:16]),
    .IF_ID_RegisterRs(ID_instruction_wire[25:21]),
    .IF_ID_RegisterRt(ID_instruction_wire[20:16]),
	//Output
    .IF_ID_Write(IF_ID_Write),
    .PC_Write(pc_write),
    .control_mux(control_mux_wire)
);


Multiplexer2to1
#(
	.NBits(14)
)
MuxResetControlSignals
(
	.Selector(control_mux_wire),
	.MUX_Data0({RegDst_wire,//1 bit
					BranchNE_wire,//1 bit
					MemReadWire, //1 bit
					BranchEQ_wire,//1 bit
					MemWriteWire,//1 bit
					MemtoRegWire,//1 bit
					ALUOp_wire,//4 bits
					ALUSrc_wire,//1 bit
					RegWrite_wire,//1 bit
					jump_wire,//1 bit
					jal_wire}),// 1 bit}),
	.MUX_Data1(14'b0000000_0000000),
	
	.MUX_Output(Mux_Control_or_Flush)

);



Multiplexer2to1
#(
	.NBits(32)
)
Flush_PC
(
	.Selector(pc_write),
	.MUX_Data0(PC_4_wire),
	.MUX_Data1(PC_wire - 4),
	
	.MUX_Output(PC_flushed_or_PC4Wire)

);

//************************HAZARD DET. UNIT*********************************/
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
	.dataInput({	Mux_Control_or_Flush, //14 bits
					ID_PC_4_wire,//32 bits
					ReadData1_wire,//32 bits
					ReadData2_wire,//32 bits
					InmmediateExtend_wire,//32 bits
					ID_instruction_wire//32 bits
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


ForwardUnit
forwardUnit
(
.clk(clk),
.EX_MEM_RegWrite(MEM_RegWrite_wire),
.EX_MEM_RegisterRd(MEM_instruction_wire[15:11]),
.MEM_WB_RegisterRd(WB_instruction_wire[15:11]),
.ID_EX_RegisterRs(EX_instruction_wire[25:21]),
.ID_EX_RegisterRt(EX_instruction_wire[20:16]),
.MEM_WB_RegWrite(WB_RegWrite_wire),
.EX_MEM_RegisterRt(MEM_instruction_wire[20:16]),
.MEM_WB_RegisterRt(WB_instruction_wire[20:16]),
.Forward_A(forwardA),
.Forward_B(forwardB)
);

//*************************MUXES DE 3*********************************/
Mux3to1
#(
	.NBits(32)
)
mux3to1_a
(
	.Selector(forwardA),
	.MUX_Data0(EX_ReadData1_wire),
	.MUX_Data1(MuxALUsrcORRamDataWire),
	.MUX_Data2(MEM_ALUResult_wire),
	.MUX_Output(mux3to1_a_output)
);

Mux3to1
#(
	.NBits(32)
)
mux3to1_b
(
	.Selector(forwardB),
	.MUX_Data0(salidaMuxALUsrc),
	.MUX_Data1(MuxALUsrcORRamDataWire),//Wire del mux de hasta la derecha MemtoRegWire
	.MUX_Data2(MEM_ALUResult_wire),
	.MUX_Output(mux3to1_b_output)
);
//*************************MUXES DE 3*********************************/
Pipeline
#(
	.N(170)
)
Pipeline_EX_MEM
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.nopper(1'b0),
	.dataInput({
				InmmediateExtendAnded_wire,//32 bits
				ALUResult_wire,//32 bits
				EX_ReadData2_wire,//32 bits
				WriteRegister_wire,//5 bits
				MUX_PC_wire,//32 bits
				EX_MemReadWire,//1 bit
				EX_MemWriteWire,//1 bit
				EX_MemtoRegWire,//1 bit
				EX_RegWrite_wire,//1 bit
				EX_jal_wire,//1 bit
				EX_instruction_wire //32 bits
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
				MEM_jal_wire,
				MEM_instruction_wire
				})
);

//Pipeline MEM/WB
Pipeline
#(
	.N(137)
)
Pipeline_MEM_WB 
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.nopper(1'b0),
	.dataInput({
				ramDataWire,//32 bits
				MEM_ALUResult_wire,//32 bits
				MEM_MemWriteWire,//1 bit
				MEM_MemtoRegWire,//1 bit
				MEM_RegWrite_wire,//1 bit
				MEM_jal_wire,//1 bit
				MEM_WriteRegister_wire,//5 bits
				MEM_MUX_PC_wire, //32 bits
				MEM_instruction_wire // 32 bits
				}),
	.dataOutput({
				WB_ramDataWire,
				WB_ALUResult_wire,
				WB_MemWriteWire,
				WB_MemtoRegWire,
				WB_RegWrite_wire,
				WB_jal_wire,
				WB_WriteRegister_wire,
				WB_MUX_PC_wire,
				WB_instruction_wire
				})
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
	.NewPC(PC_flushed_or_PC4Wire), //fINAL MUX PC WIRE ESTABA ANTES
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
	.MUX_Data1(EX_PC_4_wire), // ESTO SE VA A TENER QUE CAMBIAR TAMBIEN
	
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
	.A(mux3to1_a_output),
	.B(mux3to1_b_output), //Si es immediate o lo de Register File
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

Adder32bits //Este es el adder del PC_4_Wire y el dato inmediato<<2 CHECAR ESTO TAMBIEN
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
	.MUX_Data1(InmmediateExtendAnded_wire), /*********************** PROB ESTE MAL, igual el de arriba  */
	
	.MUX_Output(MUX_PC_wire) // ************ ex-mem

);


//FOR JUMP INSTRUCTION
ShiftLeft2 //Logica para la JumpAddr
J_Address_SL2
(
	.DataInput({6'b0, ID_instruction_wire[25:0]}),
	.DataOutput(jumpAddressAux)
);

Adder32bits //Logica para la JumpAddr TAL VEZ ESTE MAL TAMBIEN ESTO
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

assign ALUResultOut = WB_ALUResult_wire; //cambio

endmodule

