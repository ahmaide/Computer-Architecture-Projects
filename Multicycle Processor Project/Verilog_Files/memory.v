module memory (
  input [31:0] address,
  input [31:0] data_in,
  input flag_read,
  input flag_write,
  input clk,
  output reg [31:0] memory_output
);
  
  reg [31:0] Memory [0:31]; 
  
  integer i;

  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      Memory[i] = 0;
    end
  end
  
  always @(posedge clk) begin
    if (flag_read) begin
      memory_output <= Memory[address];
    end
      
    if (flag_write) begin
      Memory[address] <= data_in;
    end
  end
endmodule
