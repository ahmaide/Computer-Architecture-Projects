module PROCESSOR(
  input wire clock,
  output reg IF_clk,
  output reg ID_clk,
  output reg EX_clk,
  output reg MEM_clk,
  output reg WB_clk,
  output reg [31:0] jump_address,
  output reg [31:0] jar_address,
  output reg [31:0] next_pc,
  output reg [31:0] instruction,
  output reg Z,
  output reg N,
  output reg C,
  output reg [4:0] R1,
  output reg [4:0] R2,
  output reg [4:0] R3,
  output reg [1:0] ins_type,
  output reg [4:0] func ,
 output reg [31:0] immediate,
  output reg [31:0] bus_a,
  output reg [31:0] bus_b,
  output reg [31:0] bus_w,
  output reg [1:0] PC_src,
  output reg sec_reg,
  output reg reg_w,
  output reg ALU_op,
  output reg [2:0] ALU_func,
  output reg jal_flag,
  output reg stop_stop,
  output reg mem_read,
  output reg mem_write,
  output reg rb_data,
  output reg [31:0] ALU_result
  //output reg [31:0] memory
);

  reg [31:0] jump_addressR;
  reg [31:0] jar_addressR;
  reg ZR;
  reg [1:0] ins_typeR;
  reg [4:0] funcR;
  reg stopR;
  reg [31:0] bus_wR;
  reg [1:0] PC_srcR;
  reg reg_wR;
  
  wire IF_clkS;
  wire ID_clkS;
  wire EX_clkS;
  wire MEM_clkS;
  wire WB_clkS;
  wire [31:0] jump_addressS;
  wire [31:0] jar_addressS;
  wire [31:0] next_pcS;
  wire [31:0] instructionS;
  wire ZS;
  wire NS;
  wire CS;
  wire [4:0] R1S;
  wire [4:0] R2S;
  wire [4:0] R3S;
  wire [1:0] ins_typeS;
  wire [4:0] funcS;
  wire [31:0] immediateS;
  wire stopS;
  wire [31:0] bus_aS;
  wire [31:0] bus_bS;
  wire [31:0] bus_wS;
  wire [1:0] PC_srcS;
  wire sec_regS;
  wire reg_wS;
  wire ALU_opS;
  wire [2:0] ALU_funcS;
  wire jal_flagS;
  wire stop_flagS;
  wire mem_readS;
  wire mem_writeS;
  wire rb_dataS;
  wire [31:0] ALU_resultS;
  wire [31:0] memory_outputS;

  
  clkOrganizer M1( clock, funcR, ins_type, IF_clkS, ID_clkS, EX_clkS, MEM_clkS, WB_clkS);
  
  instructionFetch M2(jump_addressR, jar_addressR, PC_srcR, ZR, IF_clkS, next_pcS, instructionS);
  
  Decode M3(ID_clkS, instructionS, next_pcS, R1S, R2S, R3S, ins_typeS, funcS, immediateS, stopS, jump_addressS);
  
  controlUnit M4(funcS, ins_typeS, stopS, PC_srcS, sec_regS, reg_wS, ALU_opS, ALU_funcS, jal_flagS, stop_flagS, mem_readS, mem_writeS, rb_dataS);
  
  registerFile M5(R1S, R2S, R3S, sec_regS, reg_wR, WB_clkS, bus_wR, bus_aS, bus_bS);
  
  ALU M6(bus_aS, bus_bS, immediateS, ALU_opS, ALU_funcS, EX_clkS, NS, CS, ZS, ALU_resultS);
  
  stack M7(EX_clkS, jal_flagS, stop_flagS, next_pcS, jar_addressS);
  
  memory M8(ALU_resultS, bus_bS, mem_readS, mem_writeS, MEM_clkS, memory_outputS);
  
  mux2x1 M9(ALU_resultS, memory_outputS, rb_dataS, bus_wS);
  
  always @* begin
	jump_addressR <= jump_addressS;
    jar_addressR <= jar_addressS;
    ZR <= ZS;
    ins_typeR <= ins_typeS;
    funcR <= funcS;
    stopR <= stopS;
    bus_wR <= bus_wS;
    PC_srcR <= PC_srcS;
    reg_wR <= reg_wS;
    IF_clk <= IF_clkS;
    ID_clk <= ID_clkS;
    EX_clk <= EX_clkS;
    MEM_clk <= MEM_clkS;
    WB_clk <= WB_clkS;
    jump_address <= jump_addressS;
    jar_address <= jar_addressS;
    next_pc <= next_pcS;
    instruction <= instructionS;
    Z <= ZS;
    N <= NS;
    C <= CS;
    R1 <= R1S;
    R2 <= R2S;
    R3 <= R3S;
    ins_type <= ins_typeS;
    func <= funcS;
    immediate <= immediateS;
    bus_a <= bus_aS;
    bus_b <= bus_bS;
    bus_w <= bus_wS;
    PC_src <= PC_srcS;
    sec_reg <= sec_regS;
    reg_w <= reg_wS;
    ALU_op <= ALU_opS;
    ALU_func <= ALU_funcS;
    jal_flag <= jal_flagS;
    mem_read <= mem_readS;
    mem_write <= mem_writeS;
    rb_data <= rb_dataS;
    ALU_result <= ALU_resultS;
    //memory <= memory_outputS;
  end
  
  
initial begin
    jump_addressR = 32'b0;
    jar_addressR = 32'b0;
    ZR = 1'b0;
    ins_typeR = 2'b0;
    funcR = 5'b0;
    bus_wR = 32'b0;
    PC_srcR = 2'b0;
    reg_wR = 1'b0;
end
	

endmodule 