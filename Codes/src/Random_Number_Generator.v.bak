// Course Number: ECE 6370
// Author: 0502
// Title: Random_Number_Generator
//This module will produce a random 4-bit number as output when a button is pressed.


module Random_Number_Generator(clk, rst, Button_in, Random_Number);

	input clk, rst;
	input Button_in;
	output[3:0] Random_Number;
	reg[3:0] Random_Number;
	wire Button_invert;
	wire[3:0] count;

	assign Button_invert = ~Button_in;

	Counter Counter_module1(clk, rst, Button_invert, count);

	always @(posedge clk)
		begin
			if(rst == 0)
				Random_Number <= 0;
			else
				begin
					if(Button_invert == 0)
						Random_Number <= count;
					else
						Random_Number <= 0;
				end
		end
endmodule
