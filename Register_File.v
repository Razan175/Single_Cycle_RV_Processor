module Register_File (
    input clk, a_rst,
    input [31:0] WD3,
    input [4:0] A1,A2,A3,
    input WE3,
    output [31:0] RD1,RD2
);
    reg [31:0] Registers [0:31]; 

    //Asynchronous Read
    assign RD1 = Registers[A1];
    assign RD2 = Registers[A2];

    //Synchronous Write
    integer i;
    always @(posedge clk or negedge a_rst) begin
        if (!a_rst) 
            //Initializing the Register file
            for (i = 0; i < 32; i = i + 1) begin
                    Registers[i] <= 0;
            end
        else
        begin
            if (WE3)
                Registers[A3] <= WD3;
        end
    end
endmodule

