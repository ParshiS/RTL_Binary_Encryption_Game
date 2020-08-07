// Course Number: ECE 6370
// Author: 0502
// Title: Counter
//This module is a 4- bit binary counter which will start counting when the input is high
//and retain the final value and increment from here when the input becomes again. 

module Counter(clk, rst, Counter_in ,Counter_out);

	input clk, rst, Counter_in;
	output[3:0] Counter_out;
	reg[3:0] Counter_out;

	always @(posedge clk)
		begin
			if(rst == 0)
				begin
					Counter_out <= 0;
				end
			else 
				begin
					if(Counter_in == 1)
						begin
							if(Counter_out >= 9)
								begin
									Counter_out <= 0;
								end
							else
								begin
									Counter_out <= Counter_out+1;
								end
						end
					else
						begin
							Counter_out <= Counter_out;
						end
				end
		end
endmodule
