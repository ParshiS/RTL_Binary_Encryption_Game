// Course Number: ECE 6370 
// Final Project
// Author: 8046
// Title: User_ID_ROM_controller
// Description: This module is user ID control unit by making use of ROM

module user_id_rom_controller(user_id_inp, clk, reset, Load_pwd, GreenLed, RedLed, user_id_display, Logout_signal, address_out);

	input [3:0] user_id_inp;
	input clk, reset, Load_pwd, Logout_signal;  // Logout_signal added to separate access control from game control unit
	output GreenLed, RedLed;
	output [3:0] user_id_display;
	output [4:0] address_out;
        

	reg Load_random_num_out, Load_player2_out_value, GreenLed, RedLed;
	reg [3:0] user_id_display;
	reg [5:0] STATE;
	reg [4:0] address_out;
	reg counter_flag;

	//signals for accessing the ROM
	reg[4:0] ROM_address;
	reg[15:0] stored_pwd_ROM, entered_pwd;
	wire[3:0] ROM_data;
	
	
	parameter PWD_1_DIGIT = 0, PWD_2_DIGIT = 1, PWD_3_DIGIT = 2, PWD_4_DIGIT = 3, DIGIT_1_FETCH = 4, WAIT_CYCLE1_DIG_1 = 5,  WAIT_CYCLE2_DIG_1 = 6,
	CATCH_1_DIGIT = 7, DIGIT_2_FETCH = 8, WAIT_CYCLE1_DIG_2 = 9,  WAIT_CYCLE2_DIG_2 = 10, CATCH_2_DIGIT = 11, DIGIT_3_FETCH = 12, WAIT_CYCLE1_DIG_3 = 13, 
	WAIT_CYCLE2_DIG_3 = 14, CATCH_3_DIGIT = 15, DIGIT_4_FETCH = 16, WAIT_CYCLE1_DIG_4 = 17,  WAIT_CYCLE2_DIG_4 = 18, CATCH_4_DIGIT = 19, AUTHORIZE = 20, CHECK_FOR_LOGOUT=21;

	user_id_rom mem(ROM_address ,clk , ROM_data);
	//wdt_Timer_1s ts(Pause_value_count, clk, reset, Counter_out, Pause_Timeout_signal); // for lab4

	always @(posedge clk)
	  begin
	    
	    if(reset == 0)
	       begin
                 
		 RedLed<=1'b1; GreenLed<=1'b0;
		 user_id_display <=4'b1010;  // display of password as A under reset condition
		 stored_pwd_ROM <= 0;
		 entered_pwd <= 0;
		 ROM_address <= 0;
		 counter_flag <= 0;
		 STATE <= PWD_1_DIGIT;
		 address_out <= 0;
		 //stop_signal_to_pwd <= 0;

	       end
	    else
	       begin
		 case(STATE)

///////////////////////////////////////////////////////////////////////// new states are added for ROM
		   PWD_1_DIGIT:
			begin
			  if(Load_pwd == 1)
			     begin
				user_id_display <= user_id_inp;
				entered_pwd[15:12] <= user_id_inp;
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
				user_id_display <= user_id_inp;
				entered_pwd[11:8] <= user_id_inp;
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
				user_id_display <= user_id_inp;
				entered_pwd[7:4] <= user_id_inp;
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
				
				user_id_display <= user_id_inp;
				entered_pwd[3:0] <= user_id_inp;
				STATE <= DIGIT_1_FETCH;
			     end
			  else
			     begin
				STATE <= PWD_4_DIGIT;
			     end
			end 

		   DIGIT_1_FETCH:
			begin
			  ROM_address <= 0;
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
/////////////////////////////////////////////////////////////////////////////// end of new added states for ROM
		   AUTHORIZE:
			begin
			  if( entered_pwd == stored_pwd_ROM)
			     begin
		 		RedLed <= 1'b0;
		 		GreenLed <= 1'b1;
				STATE <= CHECK_FOR_LOGOUT;
                                counter_flag <= 0;
				address_out <= ROM_address - 3;
			     end
			  else
			     begin
                                if (counter_flag <= 4)
					begin
					ROM_address <= ROM_address + 1;
					STATE <= WAIT_CYCLE1_DIG_1;
                                	counter_flag <= counter_flag + 1;
					stored_pwd_ROM <= 0;
					end
				else
					begin
					RedLed <= 1'b1;
					GreenLed <= 1'b0;
					STATE <= AUTHORIZE;
					//stop_signal_to_pwd <= 1;
					end
                                
			     end
			end 

                   CHECK_FOR_LOGOUT:   // new state added for checking logout condition coming from game control unit
                       
			begin
			  if( Logout_signal == 1)
			     begin
				STATE <= PWD_1_DIGIT;
		 	  	ROM_address <= 0;
		 	  	RedLed <= 1'b1;
		 	  	GreenLed <= 1'b0;
		 	  	user_id_display <= 4'b1010;
		 	  	stored_pwd_ROM <= 0;
				counter_flag <= 0;
		 	  	entered_pwd<= 0;
				address_out <= 0;

			     end
			  else
			     begin
				STATE <= CHECK_FOR_LOGOUT;
			     end
			end
                    default:
			begin
		 	  STATE <= PWD_1_DIGIT;
		 	   ROM_address<= 0;
		 	   RedLed<= 1'b1;
		 	   GreenLed<= 1'b0;
		 	   user_id_display <= 4'b1010;
		 	   stored_pwd_ROM<= 0;
		 	   entered_pwd<= 0;
			   counter_flag <= 0;
			   address_out <= 0;
			


			end
               endcase
        end
    end
endmodule
