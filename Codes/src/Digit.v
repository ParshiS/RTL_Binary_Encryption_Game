// Course Number: ECE 6370 
// Author: 0502 
// Title: Digit
// This module shows how a each single digit module in timer works

module Digit(clk, rst, Binary_in, Binary_load, Borrow_disable, dec, Binary_out, Borrow_req, TimeOut);
	
	input clk, rst;
	input Binary_load, Borrow_disable, dec;
	input[3:0] Binary_in;
	output[3:0] Binary_out;
	output Borrow_req, TimeOut;

	reg[3:0] Binary_out;
	reg Borrow_req, TimeOut;

	always @(posedge clk)
		begin
		     if( rst == 0)
		    	 begin
			       Binary_out <= 0;
			       Borrow_req <= 0;
			       TimeOut <= 0;
			       Binary_out <= 0;
		    	 end
		     else
		    	 begin
			       if( Binary_load == 1 )
				  begin
					Borrow_req <= 0;
					TimeOut <= 0;

					if( Binary_in > 9 )
					    Binary_out <= 9;
					else
					     Binary_out <= Binary_in;
				  end
			       else
				  begin
				       if( dec == 1 )
					  begin
					       if( Binary_out == 0 )
						  begin
						       if( Borrow_disable == 0 )
							  begin
								Binary_out <= 9;
								TimeOut <= 0;
								Borrow_req <= 1;
							  end
						       else 
							  begin
								Borrow_req <= 0;
								Binary_out <= 0;
								TimeOut <= 1;
							  end
						       
						  end
					       else
						  begin
						       if( Binary_out == 1 )
							   begin
								if( Borrow_disable == 1 )
								   begin 
									TimeOut <= 1;
									Borrow_req <= 0;
									Binary_out <= 0;
								   end
								else
								   begin 
									Binary_out <= Binary_out - 1;
									TimeOut <= 0;
									Borrow_req <= 0;
								   end
							   end
						       else
							   begin
								Binary_out <= Binary_out - 1;
								TimeOut <= 0;
								Borrow_req <= 0;
							   end
						  end //end for else of Binary_out ==0
					  end //end for dec
				       else
					  begin
						TimeOut <= TimeOut;
						Binary_out <= Binary_out;
						Borrow_req <= 0;	
						/////////////added this part to correct Bug 1 in my bug reprt 3/30/2019
						if( Borrow_disable == 1 && Binary_out == 0 )
						    begin
							Binary_out <= 0;
							TimeOut <= 1;
							Borrow_req <= 0;
						    end		
						/////////////added this part to correct Bug 1 in my bug reprt 3/30/2019				       
					  end //end of else for dec


				  end //end for else of Binary Load
		    	 end //end for else of reset
		end //end for always

endmodule
