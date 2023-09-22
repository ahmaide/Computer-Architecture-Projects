module Decode (
	input clk,
	input [31:0] instruction,
	input signed [31:0] PCprev,
	output reg [4:0] r1,
	output reg [4:0] r2,
	output reg [4:0] r3,
	output reg [1:0] insType,
	output reg [4:0] func,
	output wire [31:0] immediate,
	output reg stop, 
	output wire [31:0] jumpPc
);

reg [31:0] offset0;
reg [31:0] offset1;

reg [1:0] insTypeFl;
reg [4:0] funFl;
reg [31:0] immediateFl;

always @(posedge clk) 
begin
	func <= instruction[31:27];
	funFl <= instruction[31:27];
	
	r1 <= instruction[26:22];
	r2 <= instruction[21:17];
	r3 <= instruction[16:12];
	
	insType <= instruction[2:1];
	insTypeFl <= instruction[2:1];
	
	stop <= instruction[0];
	
	if (instruction[2:1] == 2'b01 && instruction[31:27] == 5'b0) 
	begin
		immediateFl <= {offset0[31:14], instruction[16:3]};
	end
	
	else if(instruction[2:1] == 2'b01 && instruction[31:27] >= 5'b00001)
	begin
		if(instruction[16]==0) begin
			immediateFl <= {offset0[31:14], instruction[16:3]};
		end
		else begin
			immediateFl <= {offset1[31:14], instruction[16:3]};
		end
	end
	
	else if (instruction[2:1] == 2'b10) 
	begin
		if(instruction[26]==1) begin
			immediateFl <= {offset1[31:24], instruction[26:3]};
		end
		else begin
			immediateFl <= {offset0[31:24], instruction[26:3]};
		end
		
	end 
	else begin
		immediateFl <= {offset0[31:5], instruction[11:7]};
	end 	
end 

	assign jumpPc = immediateFl + PCprev - 4;
	assign immediate = immediateFl;

initial begin

	offset0 <= 32'b0;
	offset1 <= 32'b11111111111111111111111111111111;

end
endmodule