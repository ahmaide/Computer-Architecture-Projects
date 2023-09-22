module stack(
    input wire clk,
    input wire jal,
    input wire stop,
    input wire [31:0] pc,
    output reg [31:0] next_pc
);

reg [4:0] sp;
reg [31:0] stack_mem [0:31];

	always @(posedge clk) begin
        if (jal) begin
            stack_mem[sp] <= pc;
            sp <= sp + 1;
        end else if (stop) begin
            next_pc <= stack_mem[sp-1];
            sp <= sp - 1;
        end
    end
endmodule





