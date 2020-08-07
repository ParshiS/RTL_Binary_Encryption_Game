// Course Number: ECE 6370 
// Author: 0502 
// Title: digitTimer
// This module shows the working of Timer module

module digitTimer (clk, rst, Binary_Tens_in, Binary_Units_in, Timer_Load, dec, Binary_Tens_out, Binary_Units_out, TimeOut_Final);

	input clk, rst;
	input Timer_Load, dec;
	input [3:0] Binary_Tens_in, Binary_Units_in;
	output [3:0] Binary_Tens_out, Binary_Units_out;
	output TimeOut_Final;

	wire Borrow_req_Units, TimeOut_Tens, Borrow_req_Tens;

	Digit Digit_Units(clk, rst, Binary_Units_in, Timer_Load, TimeOut_Tens, dec, Binary_Units_out, Borrow_req_Units, TimeOut_Final);
	Digit Digit_Tens(clk, rst, Binary_Tens_in, Timer_Load, 1'b1, Borrow_req_Units, Binary_Tens_out, Borrow_req_Tens, TimeOut_Tens);
endmodule
