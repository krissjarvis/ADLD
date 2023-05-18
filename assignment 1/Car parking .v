module assign_tb();
reg f_sen;
reg b_sen;
reg [3:0] pass;
reg [3:0] crt_pass;
wire g_open;

ASSIGN dut (f_sen,b_sen,pass,g_open);

initial begin
//crt password
crt_pass=4'b1001;
#1 f_sen=0;
#1 b_sen=0;
#5 f_sen= 1 ; 
 pass=4'b1001;
#5 b_sen= 1;

$display ("f_sen :%d\n,pass=%d is right password\n,b_sen :%d,",f_sen,pass,b_sen);



//incrt password
crt_pass=4'b1001;
#1 f_sen=0;
#1 b_sen=0;

#5 f_sen= 1;
#5 pass=4'b1000;
#5 b_sen= 0;
$display ("f_sen :%d\n,pass=%d is wrong password\n,b_sen :%d\n,",f_sen,pass,b_sen);


end
initial 
 begin
	$monitor ($time,"f_sen=%2d,b_sen=%2d",f_sen,b_sen);
	#200  $finish;
 end
endmodule

//multiple car enters the car park sys

module ASSIGN(f_sen,b_sen,pass,g_open);
input f_sen,b_sen;    // front_sensor and bak_sensor;
input [3:0]pass;    // password we are gonna enter
output reg g_open;      // gate open when the entered password is right;
reg [3:0] crt_pass;  // correct_password
reg [1:0] state;     //to build a case 
parameter entry=2'b00, in_pass=2'b01,car_to_pass=2'b10; //entry=initially when car enter the park sys, in_pass=input password,car_to_pass=when car passes the gate

always @(posedge f_sen, posedge b_sen)
begin
g_open <= 0;
case(state)
entry :
begin

if(f_sen)
begin
state <=in_pass;   // if front sensor senses the car , it redirects to enter the password
end 
end
in_pass :
begin
crt_pass <= pass;
state <= car_to_pass;   // if entered password matches the crt password then it redirects to car_to_pass.
end
car_to_pass :
begin
if(b_sen)
begin
if(pass == crt_pass)       // when entered password is right gate opens and car passes and then it redirects to entry case
g_open <= 1;
state <=entry;
end
else 
begin
crt_pass<=0;                 // if password entered is wrong then the it will ask enter the password.
state <= in_pass;
end
end
endcase
end 
endmodule
