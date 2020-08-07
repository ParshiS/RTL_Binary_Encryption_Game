// Course Number: ECE 6370 
// Author: 0502 
// Title: Button_Shaper 
// This module produces a single cycle pulse when button is pressed

module Button_Shaper(Button_in,clk,rst,Pulse_out);

	input Button_in;
	input clk, rst;
	output Pulse_out;
	reg Pulse_out;

	parameter INITIAL = 0, PULSE = 1, WAIT = 2;
	reg[1:0] Present_State, Next_State;

	always @(Button_in, Present_State)
	 begin
	  case(Present_State)
	    INITIAL: 
	      begin
	        Pulse_out <= 0;
	        if(Button_in == 1)
	          Next_State <= INITIAL;
	        else
	          Next_State <= PULSE;              
	      end
	    PULSE:
	      begin
	        Pulse_out <= 1;
	        Next_State <= WAIT;
	      end
	    WAIT:
	      begin
	        Pulse_out <= 0;
	        if(Button_in == 1)
	          Next_State <= INITIAL;
	        else
	          Next_State <= WAIT;
	      end
	    default:
	      begin
	        Pulse_out <= 0;
	        Next_State <= INITIAL;
	      end
	 endcase
	end

	always @(posedge clk)
	 begin	 
	  if(rst == 0)
	     Present_State <= INITIAL;
	  else
	     Present_State <= Next_State;
	 end

endmodule
