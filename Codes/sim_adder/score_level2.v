module score_level2(clock, reset,clear, player_toggle,RNG_op, rng_load, Player_Ld, SC_Tens, SC_Units,ledr_out ,
 ledg_out);

	input clock, reset;
	input rng_load, Player_Ld;
	input clear;
	input[3:0] player_toggle;
	output reg [3:0] SC_Tens, SC_Units;
	input  [3:0] RNG_op;
	//reg [1:0]cnt;
	
	output ledr_out , ledg_out;
    reg ledr_out , ledg_out;


	parameter LOAD_WAIT = 0, SCORE_CAL = 1, WAIT_RNGLOAD =2;
	
	reg [1:0] state;

	always@(posedge clock) 
	  begin
		if(reset == 0 | clear==1)
			 begin
   				SC_Tens <= 0;
   				SC_Units <= 0;
				ledr_out <=0 ; 
                                ledg_out <=0;
							
											//cnt<= 0;
 			end
		else 
 		   	begin
				case(state) 
                
					LOAD_WAIT: 
						begin
						  if(Player_Ld == 1) begin
						  
							state <= SCORE_CAL; end
						  else begin
							state <= LOAD_WAIT; end
						end

					SCORE_CAL: 
						begin
						     if( player_toggle == RNG_op )//comparing player input with encoded value of symbol
							begin
							
							  ledr_out = 1'b0;		
							  ledg_out = 1'b1;
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
								
						        ledr_out = 1'b1;
                          ledg_out = 1'b0;
 							     SC_Units <= SC_Units;
							     SC_Tens <= SC_Tens;
							     state <= LOAD_WAIT; 
                        end
                  end							  
					WAIT_RNGLOAD: 
						begin
						
						  SC_Units <= SC_Units;
					 	  SC_Tens <= SC_Tens;
						  if(rng_load == 0)
							state <= LOAD_WAIT;
						  else
							state <= WAIT_RNGLOAD;
						end
					default:
						begin
   						     SC_Tens <= 0;
   						     SC_Units <= 0;
								  ledr_out <=0 ; 
                          ledg_out <=0;
										 
						    // cnt<=0;
						     state <= LOAD_WAIT;

						end
                
					 
				endcase				   					   									
 		   end	
	  end

endmodule 

