module Control_Unit (
    input[6:0] op,
    input [2:0] funct3,
    input  funct7,
    input  zero,sign_flag,
    output reg PCSrc,ALUSrc,RegWrite,MemWrite,ResultSrc,
    output reg [2:0] ALUControl,
    output reg [1:0] ImmSrc 
);

reg [1:0] ALUOp;
reg Branch;


always @(*) begin

    //Main Decoder
    case(op)
    7'b000_0011: {RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp} = 9'b1001_01000; 
    7'b010_0011: {RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp} = 9'b0011_1x000; 
    7'b011_0011: {RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp} = 9'b1xx0_00010; 
    7'b001_0011: {RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp} = 9'b1001_00010; 
    7'b110_0011: {RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp} = 9'b0100_0x101; 
    default:     {RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp} = 9'b0000_00000; 
    endcase

    //ALU decoder
    case(ALUOp)
    2'b00: ALUControl = 3'b000;
    2'b01: ALUControl = (funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b100) ? 3'b010 : 3'b000;
    2'b10: ALUControl = (({op[5],funct7} == 2'b11) && (funct3 == 3'b000)) ? 3'b010 : funct3;
    default: ALUControl = 0;
    endcase

    //Branch instruction MUX
    case (funct3)
    3'b000: PCSrc = zero & Branch;
    3'b001: PCSrc = (~zero) & Branch;
    3'b100: PCSrc = sign_flag & Branch;
    default: PCSrc = 0;
    endcase
end
endmodule

