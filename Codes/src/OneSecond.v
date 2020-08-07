module OneSecond(clk, rst, enable, OneSecond);

input clk, rst, enable;
output OneSecond;

wire OneMilliSec;	
	
	OneMilliSec om1 (clk, rst, enable, OneMilliSec);
	Count1000   c1  (clk, rst, OneMilliSec, OneSecond);

endmodule
	
