module GameControl(clk, rst, User_Key, RNG_Load, Player_Load, Game_Control, Authorization_Success, Level_Select,WatchDog_TimeOut, WatchDog_Enable, Timer_TimeOut, 
Clear_Score_Level2, Clear_Score_Level3, RNG_Load_Final,RNG2_Load_Final, Player_Load_Final, Timer_Load, Timer_Enable, Timer_Tens_Digit, Timer_Units_Digit, Digit_FirstRound, LogOut, Game_Level, ScoreTens_Level2, ScoreUnits_Level2, ScoreTens_Level3, ScoreUnits_Level3, Winner_Index, Winner_Level2_Tens, Winner_Level2_Units, Winner_Level3_Tens, Winner_Level3_Units, Level3_Count );

	input clk, rst;
	input RNG_Load, Player_Load, Game_Control, Authorization_Success, WatchDog_TimeOut, Timer_TimeOut;
	input [1:0] Level_Select;
	input [3:0] ScoreTens_Level2, ScoreUnits_Level2, ScoreTens_Level3, ScoreUnits_Level3;
	input [4:0] User_Key;
	output Level3_Count, WatchDog_Enable, Clear_Score_Level2, Clear_Score_Level3, RNG_Load_Final, RNG2_Load_Final, Player_Load_Final, Timer_Load, Timer_Enable, LogOut;
	output [3:0] Timer_Tens_Digit, Timer_Units_Digit, Digit_FirstRound, Winner_Index, Winner_Level2_Tens, Winner_Level2_Units, Winner_Level3_Tens, Winner_Level3_Units;
	output [2:0] Game_Level;

	reg WatchDog_Enable, Clear_Score_Level2, Clear_Score_Level3, RNG_Load_Final, RNG2_Load_Final, Player_Load_Final, Game_Control_Final, Timer_Load, Timer_Enable, LogOut;
	reg [3:0] Timer_Tens_Digit, Timer_Units_Digit, Digit_FirstRound, Winner_Index, Winner_Level2_Tens, Winner_Level2_Units, Winner_Level3_Tens, Winner_Level3_Units;

	reg Level3_Count;
	reg [2:0] Game_Level;
	reg [18:0] RAM [4:0];
	reg [7:0] Total_Score[4:0];
	wire[3:0] ActualID;
	assign ActualID=User_Key/4;

	parameter WAIT_FOR_ACCESS_GRANT = 0, CHOOSE_LEVEL = 1, LEVEL1 = 2, LEVEL2_TIMER_CONFIG = 3, 
	LEVEL2_LOAD_TIMER = 4, LEVEL2_GAME_START = 5, LEVEL2_GAME_GOING_ON = 6, LEVEL2_OVER = 7, 
	LEVEL3_TIMER_CONFIG = 8, LEVEL3_LOAD_TIMER = 9, LEVEL3_GAME_START = 10, LEVEL3_GAME_GOING_ON = 11, 
	LEVEL3_COUNT = 12, LEVEL3_WAIT = 13, GAME_OVER = 14, CHECK_LEVEL_TRANSITION = 15, PAUSE = 16, RESUME = 17, 
	LOGOUT = 18, WAIT_FOR_PASSWORD_ENTER = 19, HIGH_SCORE = 20, GAME_INTERRUPT = 21;
	reg[4:0] state;
	
	always @(posedge clk)
	  begin
	    if(rst == 0)
	      begin
		RNG_Load_Final <= 1;
		RNG2_Load_Final <= 1;
		Player_Load_Final <= 0;
		Timer_Load <= 0;
		Timer_Enable <= 0;
		LogOut <= 0;
		WatchDog_Enable <= 0;
		Digit_FirstRound <= 0;
		Game_Level <= 0;
		Clear_Score_Level2 <= 0;
	        Clear_Score_Level3 <= 0;
		state <= WAIT_FOR_ACCESS_GRANT;
		Timer_Tens_Digit <= 0;
		Timer_Units_Digit <= 0;
		Winner_Index <= 0;
		Winner_Level2_Units <= 0;
		Winner_Level2_Tens <= 0;
		Winner_Level3_Units <= 0;
		Winner_Level3_Tens <= 0;
		Level3_Count <= 0;
/////////////////////// below code should be replaced with RAM value after instantiation 
		
		RAM[4]<= 0;
		RAM[3]<= 0;
		RAM[2]<= 0;
		RAM[1]<= 0;
		RAM[0]<= 0;
///////////////////////should be replaced with RAM instantiation 
	      end
	    else
	      begin
		case(state)
		
		  WAIT_FOR_ACCESS_GRANT:
		     begin
			if(Authorization_Success == 1)
			  begin
			    state <= CHOOSE_LEVEL;
			  end
			else
			  begin
			    state <= WAIT_FOR_ACCESS_GRANT;
			  end
		     end

		  CHOOSE_LEVEL:
		     begin
		       Game_Level <= 0;
				 Clear_Score_Level3 <= 1;
		       if(Game_Control == 1)
		 	 begin
			   if(Level_Select == 0)
			     begin
			       state <= HIGH_SCORE;
			     end
			   else if(Level_Select == 1)
			     begin
			       state <= LEVEL1;
			     end
			   else if(Level_Select == 2)
			     begin
			       if(RAM[ActualID][18]== 1)
			         begin
			    	  state <= LEVEL2_TIMER_CONFIG;
			         end
			       else
			         begin
			    	  state <= LEVEL1;
			         end
			     end
			   else if(Level_Select == 3)
			     begin
			       if(RAM[ActualID][17]== 1)
			         begin
			    	  state <= LEVEL3_TIMER_CONFIG;
			         end
			       else if(RAM[ActualID][18]== 1)
			         begin
			    	  state <= LEVEL2_TIMER_CONFIG;
			         end
			       else
			         begin
			    	  state <= LEVEL1;
			         end
			     end
			   else
			     begin
			       state <= LEVEL1;
			     end
		 	 end
		       else
		 	 begin
			   state <= CHOOSE_LEVEL;
		 	 end
		     end

		  LEVEL1:
		     begin
			Game_Level <= 1;
		        RNG_Load_Final <= 1;
		        RNG2_Load_Final <= 1;
			Player_Load_Final <= 0;
			WatchDog_Enable <= 1;
			if(Game_Control == 1)
			  begin
			    WatchDog_Enable <= 0;
			    state <= GAME_INTERRUPT;
			  end
			else
			  begin
			    if(Player_Load == 1)
			      begin
				if(Digit_FirstRound >= 9)
				  begin
				    RAM[ActualID][18] <= 1;
				    Digit_FirstRound <= 0;
				  end
				else
				  begin
				    Digit_FirstRound <= Digit_FirstRound + 1;
				  end
			      end
			    else
			      begin
				Digit_FirstRound <= Digit_FirstRound;
			      end
			    state <= LEVEL1;
			  end
		     end
////////////////
		  LEVEL2_TIMER_CONFIG:
		     begin
			Game_Level <= 2;
			Timer_Enable <= 0;
			Timer_Tens_Digit <= 9;
			Timer_Units_Digit <= 0;
			state <= LEVEL2_LOAD_TIMER;
		     end

		  LEVEL2_LOAD_TIMER:
		     begin
			  Clear_Score_Level2 <=1;
			Game_Level <= 2;
			Timer_Enable <= 0;
			Timer_Load <= 1;
			state <= LEVEL2_GAME_START;
		     end

		  LEVEL2_GAME_START:
		     begin
			Clear_Score_Level2 <=0;
			Game_Level <= 2;
			Timer_Load <= 0;
			Timer_Enable <= 0;
			if(Game_Control == 1)
			  begin
			    state <= LEVEL2_GAME_GOING_ON;
			  end
			else
			  begin
			    state <= LEVEL2_GAME_START;
			  end
		     end

		  LEVEL2_GAME_GOING_ON:
		     begin
			Game_Level <= 2;
			Timer_Enable <= 1;
			WatchDog_Enable <= 1;
			if(Game_Control == 1)
			  begin
			    WatchDog_Enable <= 0;
			    state <= GAME_INTERRUPT;
			  end
			else
			  begin
			    if(Timer_TimeOut == 1)
			      begin
				Timer_Enable <= 0;
				RNG_Load_Final <= 1;
				RNG2_Load_Final <= 1;
				Player_Load_Final <= 0;
				state <= LEVEL2_OVER;
			      end
			    else
			      begin
				RNG_Load_Final <= RNG_Load;
				RNG2_Load_Final <= 1;
				Player_Load_Final <= Player_Load;
				state <= LEVEL2_GAME_GOING_ON;
			      end   
			  end
		     end

		  LEVEL2_OVER:
		     begin
			Game_Level <= 2;
			Timer_Load <= 0;
			Timer_Enable <= 0;
			RNG_Load_Final <= 1;
			RNG2_Load_Final <= 1;
			Player_Load_Final <= 0;
			RAM[ActualID][17] <= 1;
			RAM[ActualID][12:9]<= ScoreUnits_Level2;
			RAM[ActualID][16:13]<= ScoreTens_Level2;
			if(Game_Control == 1)
			  begin
			    state <= LEVEL3_TIMER_CONFIG;
			  end
			else
			  begin
			    state <= LEVEL2_OVER;
			  end
		     end
////////////////

////////////////
		  LEVEL3_TIMER_CONFIG:
		     begin
			Game_Level <= 3;
			Clear_Score_Level2 <= 1;
			Timer_Enable <= 0;
			Timer_Tens_Digit <= 6;
			Timer_Units_Digit <= 0;
			state <= LEVEL3_LOAD_TIMER;
		     end

		  LEVEL3_LOAD_TIMER:
		     begin
			  Clear_Score_Level3 <=1;
			Game_Level <= 3;
			Timer_Enable <= 0;
			Timer_Load <= 1;
			state <= LEVEL3_GAME_START;
		     end

		  LEVEL3_GAME_START:
		     begin
			  Clear_Score_Level3 <=0;
			Game_Level <= 3;
			Timer_Load <= 0;
			Timer_Enable <= 0;
			if(Game_Control == 1)
			  begin
			    state <= LEVEL3_GAME_GOING_ON;
			  end
			else
			  begin
			    state <= LEVEL3_GAME_START;
			  end
		     end

		  LEVEL3_GAME_GOING_ON:
		     begin
			Game_Level <= 3;
			Timer_Enable <= 1;
			if(Game_Control == 1)
			  begin
			    WatchDog_Enable <= 0;
			    state <= GAME_INTERRUPT;
			  end
			else
			  begin
			    if(Timer_TimeOut == 1)
			      begin
				Timer_Enable <= 0;
				RNG_Load_Final <= 1;
				RNG2_Load_Final <= 1;
				Player_Load_Final <= 0;
				state <= GAME_OVER;
			      end
			    else
			      begin
				if(RNG_Load == 0)
				  begin
				  		case(Level3_Count)
				      0: begin RNG_Load_Final <= RNG_Load; RNG2_Load_Final <= 1;  end
				      1: begin RNG_Load_Final <= 1; RNG2_Load_Final <= RNG_Load;  end
				      default: begin RNG_Load_Final <= 1; RNG2_Load_Final <= 1;  end
				    endcase
				    state <= LEVEL3_COUNT;
				  end
				else
				  begin
				    RNG_Load_Final <= 1; 
				    RNG2_Load_Final <= 1;
				    state <= LEVEL3_GAME_GOING_ON;
				  end
				Player_Load_Final <= Player_Load;
			      end   
			  end
		     end

		  LEVEL3_COUNT:
		     begin
			Game_Level <= 3;
			Level3_Count <= ~ Level3_Count;
			state <= LEVEL3_WAIT;
		     end

		  LEVEL3_WAIT:
		     begin
			Game_Level <= 3;
			if(RNG_Load == 1)
			  begin
			    state <= LEVEL3_GAME_GOING_ON;
			  end
			else
			  begin
			    state <= LEVEL3_WAIT;
			  end
		     end

		  GAME_OVER:
		     begin
			Game_Level <= 3;
			Timer_Load <= 0;
			Timer_Enable <= 0;
			RNG_Load_Final <= 1;
			Player_Load_Final <= 0;
			RAM[ActualID][8] <= 1;
			RAM[ActualID][3:0]<= ScoreUnits_Level3;
			RAM[ActualID][7:4]<= ScoreTens_Level3;
			if(Game_Control == 1)
			  begin			    
			    state <= CHOOSE_LEVEL;
			  end
			else
			  begin
			    state <= GAME_OVER;
			  end
		     end

		  LOGOUT:
		     begin
			Timer_Enable <= 0;
			RNG_Load_Final <= 1;
			Player_Load_Final <= 0;
			Timer_Tens_Digit <= 6;
			Timer_Units_Digit <= 0;
			Timer_Load <= 1;
			LogOut <= 1;
		   Clear_Score_Level2 <= 1;
	      Clear_Score_Level3 <= 1;
			state <= WAIT_FOR_PASSWORD_ENTER;
		     end

		  WAIT_FOR_PASSWORD_ENTER:
		     begin
			Timer_Load <= 0;
			Timer_Enable <= 0;
			RNG_Load_Final <= 1;
			Player_Load_Final <= 0;
			LogOut <= 0;
			Clear_Score_Level2 <= 0;
			Clear_Score_Level3 <= 0;
			state <= WAIT_FOR_ACCESS_GRANT;
		     end
			  		 
////////////////

		  CHECK_LEVEL_TRANSITION:
		     begin
		       Timer_Enable <= 0;
		       RNG_Load_Final <= 1;
		       Player_Load_Final <= 0;
		       WatchDog_Enable <= 0;
		       

		       case(Game_Level)	 
			1: 
			  begin
			    if(RAM[ActualID][18]== 1)
			      begin
				state <= LEVEL2_TIMER_CONFIG;
			      end
			    else
			      begin
				state <= LEVEL1;
			      end
			  end
			2: 
			  begin
			    if(RAM[ActualID][17]== 1)
			      begin
				state <= LEVEL3_TIMER_CONFIG;
			      end
			    else
			      begin
				state <= LEVEL2_GAME_GOING_ON;
			      end
			  end
			3: 
			  begin
			    if(RAM[ActualID][8]== 1)
			      begin
				state <= LEVEL1;
			      end
			    else
			      begin
				state <= LEVEL3_GAME_GOING_ON;
			      end
			  end
			default: 
			  begin
			    if(RAM[ActualID][18]== 0)
			      begin
				state <= LEVEL1;
			      end
			    else if(RAM[ActualID][17]== 0) 
			      begin
				state <= LEVEL2_TIMER_CONFIG;
			      end
			    else if(RAM[ActualID][8]== 0) 
			      begin
				state <= LEVEL3_TIMER_CONFIG;
			      end
			    else 
			      begin
				state <= LEVEL1;
			      end
			  end
		       endcase
			
		     end

		  PAUSE:
		     begin
		       Timer_Enable <= 0;
		       WatchDog_Enable <= 1;
		       RNG2_Load_Final <= 1;
		       RNG_Load_Final <= 1;
		       Player_Load_Final <= 0;
		       if(WatchDog_TimeOut == 1)
			       begin
			    WatchDog_Enable <= 0;
			    state <= RESUME;
			       end
		       else
			  begin
		       if(Game_Control == 1)
			      begin
			        WatchDog_Enable <= 0;
			        state <= LOGOUT;
			      end
		       	    else
			      begin
			        state <= PAUSE;
			        
			      end
			  end
		     end

		  RESUME:
		     begin
		       Timer_Enable <= 0;
		       RNG_Load_Final <= 1;
		       RNG2_Load_Final <= 1;
		       Player_Load_Final <= 0;
		       WatchDog_Enable <= 0;
		       
		       if(Game_Control == 1)
			 begin
		       	   case(Game_Level)
			     1: begin state <= LEVEL1; end
			     2: begin state <= LEVEL2_GAME_GOING_ON; end
			     3: begin state <= LEVEL3_GAME_GOING_ON; end
			     default: begin state <= LEVEL1; end
		       	   endcase
			 end
		       else
			 begin
		       	   state <= RESUME;
			 end
		     end

		  HIGH_SCORE:
		     begin
			Game_Level <= 4;
			Total_Score[4][7:0] <=(RAM[4][7:4]*10 + RAM[4][3:0]) + (RAM[4][16:13]*10 + RAM[4][12:9]);
			Total_Score[3][7:0] <=(RAM[3][7:4]*10 + RAM[3][3:0]) + (RAM[3][16:13]*10 + RAM[3][12:9]);
			Total_Score[2][7:0] <=(RAM[2][7:4]*10 + RAM[2][3:0]) + (RAM[2][16:13]*10 + RAM[2][12:9]);
			Total_Score[1][7:0] <=(RAM[1][7:4]*10 + RAM[1][3:0]) + (RAM[1][16:13]*10 + RAM[1][12:9]);
			Total_Score[0][7:0] <=(RAM[0][7:4]*10 + RAM[0][3:0]) + (RAM[0][16:13]*10 + RAM[0][12:9]);
			if(Total_Score[4][7:0] > Total_Score[3][7:0] && Total_Score[4][7:0] > Total_Score[2][7:0] && Total_Score[4][7:0] > Total_Score[1][7:0] && Total_Score[4][7:0] > Total_Score[0][7:0])
			  begin
			     Winner_Index <= 4;
			     Winner_Level2_Units <= RAM[4][12:9];
			     Winner_Level2_Tens <= RAM[4][16:13];
			     Winner_Level3_Units <= RAM[4][3:0];
			     Winner_Level3_Tens <= RAM[4][7:4];
			  end
			else if(Total_Score[3][7:0] > Total_Score[4] [7:0]&& Total_Score[3][7:0] > Total_Score[2][7:0] && Total_Score[3][7:0] > Total_Score[1][7:0] && Total_Score[3][7:0] > Total_Score[0][7:0])
			  begin
			     Winner_Index <= 3;
			     Winner_Level2_Units <= RAM[3][12:9];
			     Winner_Level2_Tens <= RAM[3][16:13];
			     Winner_Level3_Units <= RAM[3][3:0];
			     Winner_Level3_Tens <= RAM[3][7:4];
			  end
			  else if(Total_Score[2][7:0] > Total_Score[4][7:0] && Total_Score[2][7:0] > Total_Score[3][7:0] && Total_Score[2][7:0] > Total_Score[1][7:0] && Total_Score[2][7:0] > Total_Score[0][7:0])
			  begin
			     Winner_Index <= 2;
			     Winner_Level2_Units <= RAM[2][12:9];
			     Winner_Level2_Tens <= RAM[2][16:13];
			     Winner_Level3_Units <= RAM[2][3:0];
			     Winner_Level3_Tens <= RAM[2][7:4];
			  end
           else if(Total_Score[1][7:0] > Total_Score[4][7:0] && Total_Score[1][7:0] > Total_Score[3][7:0] && Total_Score[1][7:0] > Total_Score[2][7:0] && Total_Score[1][7:0] > Total_Score[0][7:0])
			  begin
			     Winner_Index <= 1;
			     Winner_Level2_Units <= RAM[1][12:9];
			     Winner_Level2_Tens <= RAM[1][16:13];
			     Winner_Level3_Units <= RAM[1][3:0];
			     Winner_Level3_Tens <= RAM[1][7:4];
			  end
          else if(Total_Score[0][7:0] > Total_Score[4][7:0] && Total_Score[0][7:0] > Total_Score[3][7:0] && Total_Score[0][7:0] > Total_Score[2][7:0] && Total_Score[0][7:0] > Total_Score[1][7:0])
			  begin
			     Winner_Index <= 0;
			     Winner_Level2_Units <= RAM[0][12:9];
			     Winner_Level2_Tens <= RAM[0][16:13];
			     Winner_Level3_Units <= RAM[0][3:0];
			     Winner_Level3_Tens <= RAM[0][7:4];
			  end
                       else 
			  begin
			     Winner_Index <= 0;
			     Winner_Level2_Units <= 0;
			     Winner_Level2_Tens <= 0;
			     Winner_Level3_Units <= 0;
			     Winner_Level3_Tens <= 0;
			  end
			if(Game_Control == 1)
			  begin
			     state <= CHOOSE_LEVEL;
			  end
			else
			  begin
			     state <= HIGH_SCORE;
			  end
		
		     end

		  GAME_INTERRUPT:
		     begin
		       Timer_Enable <= 0;
		       RNG_Load_Final <= 1;
		       RNG2_Load_Final <= 1;
		       Player_Load_Final <= 0;
		       WatchDog_Enable <= 1;
		       if(WatchDog_TimeOut == 1)
			 begin
			   WatchDog_Enable <= 0;
		           state <= CHECK_LEVEL_TRANSITION;
			 end
		       else
			 begin
		           if(Game_Control == 1)
			      begin
				WatchDog_Enable <= 0;
				state <= PAUSE;
			      end
		           else
			      begin
				    state <= GAME_INTERRUPT;
			      end
			 end
		     end
		       	   

		endcase
	      end
	  end


endmodule
