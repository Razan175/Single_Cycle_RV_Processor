module Instruction_Memory (
    input [31:2] A,
    output [31:0] RD
);

reg [31:0] ROM [0:63];

assign RD = ROM[A];

endmodule

