module controlUnit (
  input wire [4:0] func,
  input wire [1:0] insType,
  input wire stopIN,
  output reg [1:0] PCSrc,
  output reg secReg,
  output reg regW,
  output reg ALUop,
  output reg [2:0] ALUfunc,
  output reg jal,
  output reg stopOUT,
  output reg memRead,
  output reg memWrite,
  output reg rbData
);

always @(*) begin
	stopOUT <= stopIN;
	
	if(insType == 2'b00) begin
		if(stopIN==1)
			PCSrc <= 2'b11;
		else
			PCSrc <= 2'b00;
		if(func==5'b00011)
			regW <= 0;
		else
			regW <= 1;
		secReg <=0;
		ALUop <= 0;
		jal <= 0;
		memRead <= 0;
		memWrite <= 0;
		rbData <= 0;
	end
	
	else if(insType == 2'b01)begin
		if(stopIN==1) begin
			PCSrc <= 2'b11;
		end
		else begin
			if(func == 5'b00100)
				PCSrc <= 2'b01;
			else
				PCSrc <= 2'b00;
		end	
		if(func < 5'b00011)
			regW <= 1;
		else
			regW <= 0;
		if(func == 5'b00100)
			ALUop <= 0;
		else
			ALUop <= 1;
		secReg <=1;
		jal <= 0;
		if(func == 5'b00010)begin
			memRead <= 1;
		    memWrite <= 0;
		    rbData <= 1;
		end
		else if(func == 5'b00011)begin
			memRead <= 0;
		    memWrite <= 1;
		    rbData <= 0;
		end
		else begin
			memRead <= 0;
		    memWrite <= 0;
		    rbData <= 0;
		end
	end
		
	else if(insType == 2'b10)begin
		if(stopIN==1)
			PCSrc <= 2'b11;
		else
			PCSrc <= 2'b10;
		secReg <=0;
		regW <= 0;
		if(func == 5'b0)
			jal <= 0;
		else
			jal <= 1;
		ALUop <= 0;
		memRead <= 0;
		memWrite <= 0;
		rbData <= 0;
	end
		
	else begin
		if(stopIN==1)
			PCSrc <= 2'b11;
		else
			PCSrc <= 2'b00;
		secReg <=0;
		regW <= 1;
		if(func[1] == 0)begin
			ALUop <= 0;
		end
		else begin
			ALUop <= 1;
		end
		jal <= 0;
		memRead <= 0;
		memWrite <= 0;
		rbData <= 0;
	end
	
	
	if(insType == 2'b11)begin
		if(func[0] == 0)
			ALUfunc <= 3'b011;
		else
			ALUfunc <= 3'b100;
	end
	else begin
		if(func == 5'b0)begin
			ALUfunc <= 3'b000;
		end
		else if(func == 5'b00001)begin
			ALUfunc <= 3'b001;
		end
		else if(func == 5'b00010 || func == 5'b00011)begin
			if(insType == 2'b00)
				ALUfunc <= 3'b010;
			else
				ALUfunc <= 3'b001;
		end
		else begin 
			ALUfunc <= 3'b010;
		end
	end
	
end

endmodule 