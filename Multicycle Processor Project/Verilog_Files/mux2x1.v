module mux2x1(
	input wire [32:0] in1,
	input wire [32:0] in2,
	input wire s,
	output reg [32:0] out
);

always @(*) begin
	if(s==0)
		out <= in1;
	else
		out <= in2;
end 
endmodule 