module score_level3(clock, reset,clear, sum_ones,sum_tens,plyr_toggle_Tens, plyr_toggle_Units, rng_load, rng2_load, Player_Ld, SC_Tens, SC_Units,verifier_flag);

	input clock, reset;
	input rng_load, Player_Ld, rng2_load;
	input clear;
	input[3:0] plyr_toggle_Tens, plyr_toggle_Units;
	output reg [3:0] SC_Tens, SC_Units;
	input  [3:0] sum_ones,sum_tens;
	output reg verifier_flag;

	parameter LOAD_WAIT = 0, SCORE_CAL = 1, WAIT_RNGLOAD =2, WAIT_RNG2LOAD =3;
	
	reg [1:0] state;

	always@(posedge clock) 
	  begin
		if(reset == 0 | clear==1)
			 begin
			 
   				SC_Tens <= 0;
   				SC_Units <= 0;
				verifier_flag <=0;
 			end
		else 
 		   	begin
				case(state)

					LOAD_WAIT: 
						begin
						  if(Player_Ld == 1)
							state <= SCORE_CAL;
						  else
							state <= LOAD_WAIT;
						end

					SCORE_CAL: 
						begin
						     if( ( sum_ones == plyr_toggle_Units ) && ( sum_tens == plyr_toggle_Tens ))
							begin
							 verifier_flag <=1;
							     if( SC_Units == 9)
								begin
								    SC_Units <= 0;
								    SC_Tens <= SC_Tens + 1;
								end
					     		     else
								begin
								    SC_Units <= SC_Units + 1;
								    SC_Tens <= SC_Tens;
								end
							     state <= WAIT_RNGLOAD;
							end
						     else
							begin
							     verifier_flag <=0;
							     SC_Units <= SC_Units;
							     SC_Tens <= SC_Tens;
							     state <= LOAD_WAIT;
							end
						end
	
					WAIT_RNGLOAD: 
						begin
						  verifier_flag <=0;
						  SC_Units <= SC_Units;
					 	  SC_Tens <= SC_Tens;
						  if(rng_load == 0)
							state <= WAIT_RNG2LOAD;
						  else
							state <= WAIT_RNGLOAD;
						end

					WAIT_RNG2LOAD: 
						begin
						  verifier_flag <=0;
						  SC_Units <= SC_Units;
					 	  SC_Tens <= SC_Tens;
						  if(rng2_load == 0)
							state <= LOAD_WAIT;
						  else
							state <= WAIT_RNG2LOAD;
						end
					default:
						begin
   						     SC_Tens <= 0;
   						     SC_Units <= 0;
						     verifier_flag <=0;
						     state <= LOAD_WAIT;
						end

				endcase				   					   									
 		   	end
	  end

endmodule 

