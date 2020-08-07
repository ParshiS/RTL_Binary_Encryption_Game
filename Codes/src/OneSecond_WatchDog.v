module OneSecond_WatchDog(clk, rst, enable, WatchDogEnable, OneSecond);

input clk, rst, enable, WatchDogEnable;
output OneSecond;

wire OneMilliSec;	
	
	OneMilliSec om1 (clk, rst, enable, OneMilliSec);
	Count1000_WatchDog   c1  (clk, rst, OneMilliSec, WatchDogEnable, OneSecond);

endmodule
	
