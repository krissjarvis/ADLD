module mips_th;
reg clk1,clk2;
integer k;
 mips32 mips(clk1,clk2);
initial 
begin
clk1=0;clk2=0;
repeat(20)
begin
 #5 clk1=1; #5 clk1=0;
 #5 clk1=2; #5 clk2=0;
end
end

initial 
begin
for(k=0;k<31;k=k+1)
mips.Reg[k] =k;
mips.Mem[0] =32'h2001000a;
mips.Mem[1] =32'h20020014;
mips.Mem[2] =32'h20030019;
mips.Mem[3] =32'h0ce77800;
mips.Mem[4] =32'h0ce77800;
mips.Mem[5] =32'h00222000;
mips.Mem[6] =32'h0ce77800;
mips.Mem[7] =32'h00832000;
mips.Mem[8] =32'hfc000000;


mips.HALTED =0;
mips.pc =0;
mips.TAKEN_BRANCH=0;
#200
for(k=0;k<31;k=k+1)
$display ("R%1d - %2d",k,mips.Reg[k]);

end
endmodule


module mips32(clk1,clk2);
input clk1,clk2;
reg [31:0] pc,if_id_ir,if_id_npc;
reg [31:0] id_ex_ir,id_ex_npc,id_ex_a,id_ex_b,id_ex_imm;
reg [2:0] id_ex_type,ex_mem_type,mem_wb_type;
reg [31:0] ex_mem_ir,ex_mem_aluout,ex_mem_b;
reg ex_mem_cond;
reg [31:0] mem_wb_tr,mem_wb_aluout,mem_wb_lmd;
reg[31:0] Reg[0:31];
reg[31:0] Mem[0:1023];
parameter ADD=6'b000000,SUB=6'b000001, AND=6'b000010,OR=6'b000011,SLT=6'b000100,MUL=6'b000101,HLT=6'b111111,LW=6'b001000,SW=6'b001001,ADDI=6'b001010,SUBI=6'b001011,SLTI=6'b001100,BNEQZ=6'b001101,BEQZ=6'b001110;
parameter RR_ALU=3'b000,RM_ALU=3'b001,LOAD=3'b010,STORE=3'b011,BRANCH=3'b100,HALT=3'b101;
reg HALTED;
reg TAKEN_BRANCH;
 
always@(posedge clk1)

if(HALTED==0)
begin 	
if(((ex_mem_ir[31:26] == BEQZ) && (ex_mem_cond==1))|| ((ex_mem_ir[31:26] == BNEQZ) && (ex_mem_cond==0)))
begin 
id_id_ir     <= #2 Mem[ex_mem_aluout];
TAKEN_BRANCH <= #2 1'b1;
if_id_npc    <=#2 ex_mem_aluout +1;
pc           <= #2 ex_mem_aluout +1;
end
else 
begin 

if_id_ir  <= #2 Mem[pc];
if_id_npc <= #2 pc+1;
pc        <= #2 pc+1;
end
end

always @(posedge clk2)
if(HALTED==0)
begin
if(id_id_ir[25:21] == 5'b00000) id_ex_a <=0;
else id_ex_a  <= #2 Reg [if_id_ir[25:21]];
if (if_id_ir[20:16] == 5'b00000) id_ex_b <=0;
else id_ex_b <= #2 Reg[if_id_ir[20:16]];
id_ex_npc  <= #2 if_if_npc;
id_ex_ir   <=#2 if_id_ir;
id_ex_imm  <=#2 {{16{if_id_ir[15]}},{if_id_ir[15:0]}};
 
case (if_id_ir[31:26])
ADD,SUB,AND,OR,SLT,MUL : id_ex_type <= #2 RR_ALU;
ADDI,SUBI,SLTI :id_ex_type <= #2 RM_ALU;
LW :            id_ex_type <= #2 LOAD;
SW :            id_ex_type <= #2 STORE;
BNEQ,BEQZ :     id_ex_type <= #2 BRANCH;
HLT:            id_ex_type <= #2 HALT;
default :       id_ex_type <= #2 HALT;
endcase
end


always @( posedge clk1)
if(HALTED==0)
begin
ex_mem_type <= #2 id_ex_type ;
ex_mem_ir  <= #2 id_ex_ir;
TAKEN_BRANCH  <= #2 0;

case ( id_ex_type)
RR_ALU : begin
case (id_ex_ir[31:26])
ADD : ex_mem_aluout  <= #2 id_ex_a + id_ex_b;
SUB : ex_mem_aluout  <= #2 id_ex_a - id_ex_b;
AND : ex_mem_aluout  <= #2 id_ex_a & id_ex_b;
OR  : ex_mem_aluout  <= #2 id_ex_a | id_ex_b;
SLT : ex_mem_aluout  <= #2 id_ex_a < id_ex_b;
MUL : ex_mem_aluout  <= #2 id_ex_a * id_ex_b;
default :  ex_mem_aluout  <= #2 32'hxxxxxxxx;
endcase 
end 
RM_ALU :begin
case(id_ex_ir[31:26])
ADDi : ex_mem_aluout  <= #2 id_ex_a + id_ex_imm;
SUBI : ex_mem_aluout  <= #2 id_ex_a - id_ex_imm;
SLTI : ex_mem_aluout  <= #2 id_ex_a < id_ex_imm;
default :  ex_mem_aluout  <= #2 32'hxxxxxxxx;
endcase
end

LOAD,STORE :
 begin 
ex_mem_aluout <= #2 id_ex_a + id_ex_imm;
ex_mem_b  <= #2 id_ex_b;

BRANCH:
begin
ex_mem_aluout <= #2 id_ex_npc + id_ex_imm;
ex_mem_cond  <= #2 (id_ex_a == 0);
end
endcase


always @ (posedge clk2)
if(HALTED == 0)
begin 
mem_wb_type <= ex_mem_type;
mem_wb_ir <= #2 ex_mem_ir;

case (ex_mem_type)
RR_ALU,RM_ALU;
mem_wb_aluout <= #2  ex_mem_aluout;
LOAD: mem_wb_lmd  <= #2 Mem [ex_mem_aluout];

STORE : if(TAKEN_BRANCH  ==0)
       Mem[ex_mem_aluout]  <= #2 ex_mem_b;
endcase 
end


always @(posedge clk1)
begin
if(TAKEN_BRANCH == 0)
case (mem_wb_type)
RR_ALU : Reg[mem_wb_ir[15:11]]  <= #2 mem_wb_aluout;
RM_ALU :  Reg[mem_wb_ir[20:16]]  <= #2 mem_wb_aluout;
LOAD :  Reg[mem_wb_ir[20:16]]  <= #2 mem_wb_lmd;
HALT : HALTED <=#2 1'b1;
endcase
end 
endmodule
