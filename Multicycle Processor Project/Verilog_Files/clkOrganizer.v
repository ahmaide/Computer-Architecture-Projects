module clkOrganizer(
	input clock,
	input wire [4:0] func,
	input wire [1:0] insType,
	output reg IF,
	output reg ID,
	output reg EX,
	output reg MEM,
	output reg RW
);

reg [2:0] state;

always @(posedge clock) begin
	
	case(state)
	
		3'b000: begin
			state<=001;
			IF<=0;
			ID<=1;
			EX<=0;
			MEM<=0;
			RW<=0;
		end
		
		3'b001: begin
			if(insType == 2'b10 && func == 5'b00000)begin
				state<=000;
				IF<=1;
				ID<=0;
				EX<=0;
				MEM<=0;
				RW<=0;
			end
			else begin
				state<=010;
				IF<=0;
				ID<=0;
				EX<=1;
				MEM<=0;
				RW<=0;
			end
		end
		
		3'b010: begin
			if(insType == 2'b10 || (insType == 2'b01 && func == 5'b00100) || (insType == 2'b00 && func == 5'b00011)) begin
				state<=000;
				IF<=1;
				ID<=0;
				EX<=0;
				MEM<=0;
				RW<=0;
			end
			else if(insType== 2'b01 && (func == 5'b00010 || func == 5'b00011))begin
				state<=011;
				IF<=0;
				ID<=0;
				EX<=0;
				MEM<=1;
				RW<=0;
			end
			else begin
				state<=100;
				IF<=0;
				ID<=0;
				EX<=0;
				MEM<=0;
				RW<=1;
			end
		end
		
		3'b011: begin
			if(insType==2'b01 && func==5'b00010) begin
				state<=100;
				IF<=0;
				ID<=0;
				EX<=0;
				MEM<=0;
				RW<=1;
			end
			else begin
				state<=000;
				IF<=1;
				ID<=0;
				EX<=0;
				MEM<=0;
				RW<=0;
			end
		end
		
		default: begin
			state<=000;
			IF<=1;
			ID<=0;
			EX<=0;
			MEM<=0;
			RW<=0;
		end
		
		
	endcase
	
end 

initial begin

	state <= 3'b111;

end

endmodule 