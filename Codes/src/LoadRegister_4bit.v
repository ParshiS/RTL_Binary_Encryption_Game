// Course Number: ECE 6370
// Author: 0502
// Title: LoadRegister_4bit
// This module is a 4 bit parallel load register.

module LoadRegister_4bit(load,reset, clk, Register_in,Register_out);

	input[3:0] Register_in;
	input load;
	output[3:0] Register_out;
	input clk,reset;
	reg[3:0] Register_out;

	always @(posedge clk)
	  begin
	    if(reset == 0)
	      begin
	       Register_out <= 4'b0000;
	      end
	    else if(load == 1)
	      begin
	       Register_out <= Register_in;
	      end
	    else
	      begin
	       
	      end
	  end

endmodule
