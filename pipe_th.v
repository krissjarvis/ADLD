module pipe_th();
parameter n=10;
wire [n-1:0] f;
reg clk;
reg [n-1:0] a,b,c,d;
pipe_examp DUT(a,b,c,d,f,clk);
initial clk=1'b0;
always #4 clk=~clk;
initial begin
#4 a=10'd10;
   b=10'd20;
   c=10'd30;
   d=10'd20;

#6 a=10'd5;
   b=10'd15;
   c=10'd25;
   d=10'd10;

#6 a=10'd1;
   b=10'd2;
   c=10'd4;
   d=10'd3;
end

initial 
begin 
$monitor($time,"F=%d",f);
#600 $finish;
end 
endmodule

module pipe_examp(a,b,c,d,f,clk);
parameter n=10;
input [n-1:0]a,b,c,d;
output [n-1:0]f;
input clk;
reg [n-1:0] l12_x1,l12_x2,l12_d,l23_x3,l23_d,l34_f;
assign f=l34_f;
always @(posedge clk)
begin
l12_x1 <= #5 a+b;
l12_x2 <= #5 c-d;
l12_d <=d;
l23_x3 <= #5  l12_x1+l12_x2;
l23_d <=l12_d;
l34_f <= #8 l23_x3 * l23_d;
end 
endmodule
