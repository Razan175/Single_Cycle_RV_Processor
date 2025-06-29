module ALU (
    input signed [31:0] SrcA,SrcB,
    input signed [2:0] ALUControl,
    output reg signed [31:0] ALUResult,
    output zero, sign_flag
);

assign zero = ALUResult == 0;
assign sign_flag = ALUResult[31];

always @(*) begin
    case(ALUControl)
    3'b000: ALUResult = SrcA + SrcB;
    3'b001: ALUResult = SrcA << SrcB;
    3'b010: ALUResult = SrcA - SrcB;
    3'b100: ALUResult = SrcA ^ SrcB;
    3'b101: ALUResult = SrcA >> SrcB;
    3'b110: ALUResult = SrcA | SrcB;
    3'b111: ALUResult = SrcA & SrcB;
    default: ALUResult = 0;
    endcase  
end 
    
endmodule
