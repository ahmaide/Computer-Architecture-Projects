module registerFile (
  input wire [4:0] r1,
  input wire [4:0] r2,
  input wire [4:0] r3,
  input wire secReg,
  input wire wb,
  input wire clock,
  input [31:0] busW,
  output reg [31:0] busA,
  output reg [31:0] busB
);

  reg [31:0] registers [0:31];
  
  always @(posedge clock) begin
    if (wb)
      registers[r2] <= busW;
  end
 
  
  
  always @(*) begin
	 busA <= registers[r1];
    if (secReg == 0)
      busB <= registers[r3];
    else
      busB <= registers[r2];
  end
  
  initial begin
    registers[0]  = 32'h0; registers[1]  = 32'h0; registers[2]  = 32'h0; registers[3]  = 32'h0;
    registers[4]  = 32'h0; registers[5]  = 32'h0; registers[6]  = 32'h0; registers[7]  = 32'h0;
    registers[8]  = 32'h0; registers[9]  = 32'h0; registers[10] = 32'h0; registers[11] = 32'h0;
    registers[12] = 32'h0; registers[13] = 32'h0; registers[14] = 32'h0; registers[15] = 32'h0;
    registers[16] = 32'h0; registers[17] = 32'h0; registers[18] = 32'h0; registers[19] = 32'h0;
    registers[20] = 32'h0; registers[21] = 32'h0; registers[22] = 32'h0; registers[23] = 32'h0;
    registers[24] = 32'h0; registers[25] = 32'h0; registers[26] = 32'h0; registers[27] = 32'h0;
    registers[28] = 32'h0; registers[29] = 32'h0; registers[30] = 32'h0; registers[31] = 32'h0;
  end

endmodule
