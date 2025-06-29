module Program_Counter (
    input clk,a_rst,load,
    input PCSrc,
    input [31:0] ImmExt,
    output reg[31:0] PC
);

wire [31:0] PCNext;

//Current cycle PC logic
always@(posedge clk or negedge a_rst)
begin
    if (!a_rst) begin
        PC <= 0;  
    end
    else
    begin
        if (load)
            PC <= PCNext;
        else
            PC <= PC;
    end
end

//Next PC calculation logic
assign PCNext = PCSrc? PC + ImmExt : PC + 4;

endmodule
