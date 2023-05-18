


module delay_timer_tb;

reg clk, trigger, reset;
reg [7:0] delay_input;
wire delayed_output;

delay_timer dut (
  .clk(clk),
  .trigger(trigger),
  .reset(reset),
  .delay_input(delay_input),
  .delayed_output(delayed_output)
);

initial begin
clk = 0;
trigger = 0;
reset = 1;
delay_input = 8'hff;
#100 reset = 0;
#10 trigger = 1;
#100 trigger = 0;
#600000 $finish;
end

always #10 clk = ~clk;

endmodule


module delay_timer (clk,trigger,reset,delay_input,delayed_output);
  input clk,reset,trigger;
 input [7:0] delay_input;
output reg delayed_output;
reg [7:0] delay_counter;

always @(posedge clk) 
begin
if (reset) 
begin
delay_counter <= 0;
delayed_output <= 0;
end 
else if (trigger)
begin
delay_counter <= delay_input;
delayed_output <= 0;
end 
else if (delay_counter != 0) 
begin
delay_counter <= delay_counter - 1;
delayed_output <= 0;
end 
else 
begin
delayed_output <= 1;
end
end
endmodule




