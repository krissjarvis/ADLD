module assign_2_tb();
reg clk,rst,s_a,s_b,s_c,s_d,c_5,c_10;
wire po_a,po_b,po_c,po_d,ch_5;
assign_2 dut(clk,rst,s_a,s_b,s_c,s_d,c_5,c_10,po_a,po_b,po_c,po_d,ch_5);

initial begin
clk=0;
rst=1;
s_a=0;
s_b=0;
s_c=0;
s_d=0;
c_5=0;
c_10=0;
#10 rst =0;
end
 always #5 clk=~clk;

initial begin
s_a=1;
c_5=1;
#20 c_5=1;
#20 c_5=1;
 $display("dispense_a=%b change_5=%b",po_a,ch_5);
s_a=0;

s_b=1;
c_5=1;
#20 c_5=1;
#20 c_10=1;
 $display("dispense_b=%b change_5=%b",po_b,ch_5);
s_b=0;

s_c=1;
c_5=1;
#40 c_5=1;
 $display("dispense_c=%b change_5=%b",po_c,ch_5);
s_c=0;

s_d=1;
c_10=1;
#50 c_10=1;
 $display("dispense_d=%b change_5=%b",po_d,ch_5);
s_d=0;

end
endmodule

module assign_2(clk,rst,s_a,s_b,s_c,s_d,c_5,c_10,po_a,po_b,po_c,po_d,ch_5);
input clk,rst,s_a,s_b,s_c,s_d,c_5,c_10;
output reg po_a,po_b,po_c,po_d,ch_5;
reg[1:0] state;
reg[2:0]total;
reg[2:0]product;
parameter[1:0]IDLE=2'b00;
parameter[1:0]WAIT=2'b01;
parameter[1:0]DISPENSE=2'b10;
always @(posedge clk,posedge rst)
begin
if(rst)
begin
state<=IDLE;
total<=0;
end
else
begin
case(state)
IDLE:
begin
if(s_a)
state<=WAIT;
else if (s_b)
state<=WAIT;
else if (s_c)
state<=WAIT;
else if (s_d)
state<=WAIT;
end
WAIT:
begin
if(c_5)
total<=total+1;
else if(c_10)
total<=total+2;
if(total>=product)
state<=DISPENSE;
end
DISPENSE:
begin
if(product==2'b00)
 po_a<=1;
else if(product==2'b01)
po_b<=1;
else if(product==2'b10)
po_c<=1;
else if(product==2'b11)
po_d<=1;
ch_5<=total-product==1;
state<=IDLE;
total<=0;
end
endcase
end
end
always @(s_a,s_b,s_c,s_d)
begin
if(s_a)
product <=2'b00;
else if (s_b)
product <=2'b01;
else if(s_c)
product <=2'b10;
else if(s_d)
product <=2'b11;
end
endmodule

