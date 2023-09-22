module instructionFetch (
  input wire [31:0] jump,
  input wire [31:0] jar,
  input wire [1:0] PCSrc,
  input wire z,
  input wire clock,
  output reg [31:0] next_pc,
  output reg [31:0] instruction
);

  reg [31:0] pc;
  reg [31:0] memory [0:20];
  
  always @(posedge clock) begin
    case (PCSrc)
      2'b00: begin
		next_pc <= pc + 32'b100;
		pc <= pc + 32'b100;
		instruction <= memory[pc/4];
	  end
		
      2'b01: begin
        if (z == 1'b0) begin
		  next_pc <= pc + 32'b100;
          pc <= pc + 32'b100;
          instruction <= memory[pc/4];
        end
        else begin
          next_pc <= jump + 32'b100;
          pc <= jump + 32'b100;
          instruction <= memory[jump/4];
        end
      end
      
      2'b10: begin
	    next_pc <= jump + 32'b100;
	    pc <= jump + 32'b100;
	    instruction <= memory[jump/4];
	  end
	  
      2'b11:begin
        next_pc <= jar + 32'b100;
        pc <= jar + 32'b100;
        instruction <= memory[jar/4];
      end
    endcase
    
	
  end
  
  initial begin

  memory[0] <= 32'b00001000010000100000000000101010; // Addi R1, R1, 5
  memory[1] <= 32'b00000000010001100000000001001010; // Andi R3, R1, 9
  memory[2] <= 32'b00010000010011000011000000000000; // Sub R6, R1, R3
  memory[3] <= 32'b00011000010011000000000000011010; // Sw R6, $(R1), 3
  memory[4] <= 32'b00010000110101000000000000111010; // Lw R10, $(R3), 7
  memory[5] <= 32'b00000010100101100000000100000110; // SLL R11, R10, 2
  memory[6] <= 32'b00011010110101100011000000000110; // SLRV R11, R11, R3
  memory[7] <= 32'b00001000000000000000000001100100; // Jal 12
  memory[8] <= 32'b00000000100011101011000000000000; // And R7, R2, R11
  memory[9] <= 32'b00100001100101000000000001000010; // BEQ R6, R10, 8
  memory[10]<= 32'b00001000010001000110000000000001; // Add R2, R1, R6, Jar
  memory[11] <= 32'b00000000000000000000000000000000; // 

  end
  
  
  initial begin
    pc <= 32'b0;
  end

endmodule
