module Data_Memory (
    input clk,
    input [31:2] A,
    input [31:0] WD,
    input WE,
    output [31:0] RD
);

reg [31:0] Data [0:63];

//Asynchronous read
assign RD = Data[A];

//Synchronous write
always @(posedge clk) begin
    if (WE)
        Data[A] <= WD;
end
endmodule

