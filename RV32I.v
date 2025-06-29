module RV32I;

reg clk,rst;

wire [31:0] PC, ImmExt;
wire PCSrc;

Program_Counter Prog_Count (
    .clk(clk),
    .a_rst(rst),
    .load(1'b1),
    .PCSrc(PCSrc),
    .ImmExt(ImmExt),
    .PC(PC)
);

wire [31:0] Instr;
Instruction_Memory IM (.A(PC[31:2]),.RD(Instr));

wire zero,sign_flag,ResultSrc,MemWrite,RegWrite;
wire [2:0] ALUControl;
wire [1:0] ImmSrc;
Control_Unit CU (
    .op(Instr[6:0]), 
    .funct3(Instr[14:12]), 
    .funct7(Instr[30]),
    .zero(zero),
    .sign_flag(sign_flag),
    .PCSrc(PCSrc),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .ALUControl(ALUControl),
    .ALUSrc(ALUSrc),
    .ImmSrc(ImmSrc),
    .RegWrite(RegWrite)
);

wire [31:0] Result,SrcA,WriteData;
Register_File RF (
    .clk(clk),
    .a_rst(rst),
    .WE3(RegWrite),
    .A1(Instr[19:15]),
    .A2(Instr[24:20]),
    .A3(Instr[11:7]),
    .WD3(Result),
    .RD1(SrcA),
    .RD2(WriteData)
);

Sign_Extend SE (.Imm(Instr[31:7]),.ImmSrc(ImmSrc),.ImmExt(ImmExt));

wire [31:0] SrcB;
MUX2x1 mux_extend (WriteData,ImmExt,ALUSrc,SrcB);

wire [31:0] ALUResult;
ALU alu (
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl),
    .zero(zero),
    .ALUResult(ALUResult),
    .sign_flag(sign_flag)
);

wire [31:0] ReadData;
Data_Memory DM (
    .clk(clk),
    .A(ALUResult[31:2]), 
    .WD(WriteData),
    .WE(MemWrite),
    .RD(ReadData)
);

MUX2x1 mux_res (ALUResult,ReadData,ResultSrc,Result);


initial begin
    $readmemh("program.txt",IM.ROM);
    rst = 0;
    #10;
    rst = 1;
end  
endmodule