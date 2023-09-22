module ALU(
  input wire [31:0] REG1,
  input wire [31:0] REG2,
  input wire [31:0] immediate,
  input wire ALU_OP,
  input wire [2:0] FUNCTION,
  input wire clk,
  output reg negative_flag,
  output reg carry_flag,
  output reg zero_flag,
  output reg [31:0] ALU_result
);


  always @(posedge clk) begin

    reg [31:0] x;  
    if (ALU_OP == 1'b1) begin
      x <= immediate;  
    end 
    
    else begin
      x <= REG2;  
    end
    
    if(ALU_OP == 1'b1)begin
	zero_flag <= (REG1 == immediate);
	negative_flag <= (REG1 < immediate); 
  end
  else begin
  zero_flag <= (REG1 == REG2);
  negative_flag <= (REG1 < REG2); 
  end
	
	
	if(FUNCTION == 3'b000 && ALU_OP == 1'b1)begin
	 ALU_result <= (immediate & REG1);
  end
  if(FUNCTION == 3'b000 && ALU_OP == 1'b0)begin
	ALU_result <= (REG2 & REG1);
  end
  
  if(FUNCTION == 3'b001 && ALU_OP == 1'b1)begin
	 ALU_result <= (immediate + REG1);
  end
  
  if(FUNCTION == 3'b001 && ALU_OP == 1'b0)begin
	ALU_result <= (REG2 + REG1);
  end
  
	
     case (FUNCTION)

      3'b010: ALU_result <= (REG1 - REG2);    
      3'b011: ALU_result <= (REG1 << immediate);
      3'b100: ALU_result <= (REG1 >> immediate); 
      3'b101: ALU_result <= (REG1 << REG2);   
      3'b110: ALU_result <= (REG1 >> REG2);   

    endcase
    
    carry_flag <= (ALU_result[31] == 1'b1); 
    
  end
endmodule
