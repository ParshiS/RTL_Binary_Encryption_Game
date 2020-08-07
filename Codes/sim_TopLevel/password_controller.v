// Course Number: ECE 6370 
// Author: 8046
// Title: password controller
// Description: This module is password control unit by making use of ROM

module password_controller(Password_inp, clk, reset, Load_pwd, GreenLed, RedLed, pswrd_display, Logout_signal, address_inp, user_id_success);

	input [3:0] Password_inp;
	input clk, reset, Load_pwd, Logout_signal, user_id_success;
	input [4:0] address_inp;
	output GreenLed, RedLed;
	output [3:0] pswrd_display;
        

	reg Load_random_num_out, Load_player2_out_value, GreenLed, RedLed;
	reg [3:0] pswrd_display;
	reg [5:0] STATE;

	//signals for accessing the ROM
	reg[4:0] ROM_address;
	reg[15:0] stored_pwd_ROM, entered_pwd;
	wire[3:0] ROM_data;
	
	
	parameter PASS_AUTHENTICATION_USER_ID = 0, PWD_1_DIGIT = 1, PWD_2_DIGIT = 2, PWD_3_DIGIT = 3, PWD_4_DIGIT = 4, DIGIT_1_FETCH = 5, WAIT_CYCLE1_DIG_1 = 6,  WAIT_CYCLE2_DIG_1 = 7,
	CATCH_1_DIGIT = 8, DIGIT_2_FETCH = 9, WAIT_CYCLE1_DIG_2 = 10,  WAIT_CYCLE2_DIG_2 = 11, CATCH_2_DIGIT = 12, DIGIT_3_FETCH = 13, WAIT_CYCLE1_DIG_3 = 14, 
	WAIT_CYCLE2_DIG_3 = 15, CATCH_3_DIGIT = 16, DIGIT_4_FETCH = 17, WAIT_CYCLE1_DIG_4 = 18,  WAIT_CYCLE2_DIG_4 = 19, CATCH_4_DIGIT = 20, AUTHORIZE = 21, CHECK_FOR_LOGOUT=22;

	password_ROM mem1(ROM_address, clk , ROM_data);
	

	always @(posedge clk)
	  begin
	    
	    if(reset == 0)
	       begin

		 RedLed<=1'b1; GreenLed<=1'b0;
		 pswrd_display <=4'b0000;
		 stored_pwd_ROM <= 0;
		 entered_pwd <= 0;
		 ROM_address <= 0;
		 STATE <= PASS_AUTHENTICATION_USER_ID;
	       end
	    else
	       begin
		 case(STATE)

                   PASS_AUTHENTICATION_USER_ID: 

			begin
			   if (user_id_success == 1)
				begin
				  STATE <= PWD_1_DIGIT;
				end
			   else 
  				begin
				  STATE <= PASS_AUTHENTICATION_USER_ID;
				end
				  
			end
		   PWD_1_DIGIT:
			begin
			  if(Load_pwd == 1)
			     begin
				entered_pwd[15:12] <= Password_inp;
				STATE <= PWD_2_DIGIT;
			     end
			  else
			     begin
				STATE <= PWD_1_DIGIT;
			     end
			end 

		   PWD_2_DIGIT:
			begin
			  if(Load_pwd == 1)
			     begin
				entered_pwd[11:8] <= Password_inp;
				STATE <= PWD_3_DIGIT;
			     end
			  else
			     begin
				STATE <= PWD_2_DIGIT;
			     end
			end 

		   PWD_3_DIGIT:
			begin
			  if(Load_pwd == 1)
			     begin
				entered_pwd[7:4] <= Password_inp;
				STATE <= PWD_4_DIGIT;
			     end
			  else
			     begin
				STATE <= PWD_3_DIGIT;
			     end
			end 

		   PWD_4_DIGIT:
			begin
			  if(Load_pwd == 1)
			     begin
				pswrd_display <= Password_inp;
				entered_pwd[3:0] <= Password_inp;
				STATE <= DIGIT_1_FETCH;
			     end
			  else
			     begin
				STATE <= PWD_4_DIGIT;
			     end
			end 

		   DIGIT_1_FETCH:
			begin
			  ROM_address <= address_inp;
			  STATE <= WAIT_CYCLE1_DIG_1;
			end 

		   WAIT_CYCLE1_DIG_1:
			begin
			  STATE <= WAIT_CYCLE2_DIG_1;
			end 

		   WAIT_CYCLE2_DIG_1:
			begin
			  STATE <= CATCH_1_DIGIT;
			end 

		   CATCH_1_DIGIT:
			begin
			  stored_pwd_ROM[15:12] = ROM_data;
			  STATE <= DIGIT_2_FETCH;
			end 

		   DIGIT_2_FETCH:
			begin
			  ROM_address <= ROM_address + 1;
			  STATE <= WAIT_CYCLE1_DIG_2;
			end 

		   WAIT_CYCLE1_DIG_2:
			begin
			  STATE <= WAIT_CYCLE2_DIG_2;
			end 

		   WAIT_CYCLE2_DIG_2:
			begin
			  STATE <= CATCH_2_DIGIT;
			end 

		   CATCH_2_DIGIT:
			begin
			  stored_pwd_ROM[11:8] = ROM_data;
			  STATE <= DIGIT_3_FETCH;
			end 

		   DIGIT_3_FETCH:
			begin
			  ROM_address <= ROM_address + 1;
			  STATE <= WAIT_CYCLE1_DIG_3;
			end 

		   WAIT_CYCLE1_DIG_3:
			begin
			  STATE <= WAIT_CYCLE2_DIG_3;
			end 

		   WAIT_CYCLE2_DIG_3:
			begin
			  STATE <= CATCH_3_DIGIT;
			end 

		   CATCH_3_DIGIT:
			begin
			  stored_pwd_ROM[7:4] = ROM_data;
			  STATE <= DIGIT_4_FETCH;
			end 

		   DIGIT_4_FETCH:
			begin
			  ROM_address <= ROM_address + 1;
			  STATE <= WAIT_CYCLE1_DIG_4;
			end 

		   WAIT_CYCLE1_DIG_4:
			begin
			  STATE <= WAIT_CYCLE2_DIG_4;
			end 

		   WAIT_CYCLE2_DIG_4:
			begin
			  STATE <= CATCH_4_DIGIT;
			end 

		   CATCH_4_DIGIT:
			begin
			  stored_pwd_ROM[3:0] = ROM_data;
			  STATE <= AUTHORIZE;
			end 

		   AUTHORIZE:
			begin
			  if( entered_pwd == stored_pwd_ROM)
			     begin
		 		RedLed <= 1'b0;
		 		GreenLed <= 1'b1;
                                STATE <= CHECK_FOR_LOGOUT;
			     end
			  else
			     begin
				STATE <= AUTHORIZE;
			     end
			end 

                   CHECK_FOR_LOGOUT:
                       
			begin
			  if( Logout_signal == 1)
			     begin
				STATE <= PASS_AUTHENTICATION_USER_ID;
		 	  	ROM_address <= 0;
		 	  	RedLed <= 1'b1;
		 	  	GreenLed <= 1'b0;
		 	  	pswrd_display <= 4'b0000;
		 	  	stored_pwd_ROM <= 0;
		 	  	entered_pwd<= 0;

			     end
			  else
			     begin
				STATE <= CHECK_FOR_LOGOUT;
			     end
			end
                    default:
			begin
		 	   STATE <= PASS_AUTHENTICATION_USER_ID;
		 	   ROM_address<= 0;
		 	   RedLed<= 1'b1;
		 	   GreenLed<= 1'b0;
		 	   pswrd_display <= 4'b0000;
		 	   stored_pwd_ROM<= 0;
		 	   entered_pwd<= 0;


			end
               endcase
        end
    end
endmodule
