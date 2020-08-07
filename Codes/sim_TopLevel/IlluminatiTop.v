// Top Level Module - Team Illuminati

module IlluminatiTop(clk, rst, UserIDIn, PwdIn, Game_Load, PlayerTensIn, PlayerUnitsIn, Player_Load_in, RNG_Load_in, Level_Select,
 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, RUsrLED, GUsrLED, RPwdLED, GPwdLED, SuccLev2LEDR, 
 SuccLev2LEDG, SuccLev3LEDR, SuccLev3LEDG, Level3_Count);

	input clk, rst;
	input[3:0] UserIDIn, PwdIn, PlayerTensIn, PlayerUnitsIn;
	input[1:0] Level_Select;
	input Game_Load, Player_Load_in, RNG_Load_in;
	output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	output RUsrLED, GUsrLED, RPwdLED, GPwdLED, SuccLev2LEDR, SuccLev2LEDG, SuccLev3LEDR, 
	SuccLev3LEDG, Level3_Count;
	
	
	wire  Player_Load, Game_Control, Clear_Score_Level2, Clear_Score_Level3, RNG_Load_Final, RNG2_Load_Final, 
		Player_Load_Final, Game_Control_Final, Timer_Load, Timer_Enable, LogOut, verifier_flag, Encrypt_on1, Encrypt_on2, Encrypt_on3, Encrypt_on4,
		Encrypt_on5, Encrypt_on6, WatchDog_TimeOut, WatchDog_Enable, Timer_TimeOut, OneSecond  ;
	wire [3:0] RNG1, RNG2, Timer_Tens_Digit, Timer_Units_Digit, Digit_FirstRound, Winner_Index, Winner_Level2_Tens, Winner_Level2_Units, Winner_Level3_Tens, 
		Winner_Level3_Units, userID , PWD, Timer_Tens_out, Timer_Units_out, sum_ones,sum_tens, PlayerTensDisp, PlayerUnitsDisp, NumOut1, NumOut2, 
		NumOut3, NumOut4, NumOut5, NumOut6, Counter_Out,ScoreTens_Level2, ScoreUnits_Level2, ScoreTens_Level3, ScoreUnits_Level3;
	wire [2:0] Game_Level; 
	wire[4:0] User_Key;
	

	 

Access_Control_Top Access_Control_Module(clk, rst, PwdIn, Game_Control, UserIDIn, Game_Control, userID , PWD, RUsrLED, GUsrLED, RPwdLED, GPwdLED, LogOut, User_Key);

GameControl Game_Control_Module(clk, rst, User_Key, RNG_Load_in, Player_Load, Game_Control, GPwdLED, Level_Select, WatchDog_TimeOut, 
WatchDog_Enable, Timer_TimeOut, Clear_Score_Level2, Clear_Score_Level3, RNG_Load_Final,RNG2_Load_Final, Player_Load_Final, Timer_Load, Timer_Enable, 
Timer_Tens_Digit, Timer_Units_Digit, Digit_FirstRound, LogOut, Game_Level, ScoreTens_Level2, ScoreUnits_Level2, ScoreTens_Level3, ScoreUnits_Level3, 
Winner_Index, Winner_Level2_Tens, Winner_Level2_Units, Winner_Level3_Tens, Winner_Level3_Units );

TimerOneSecond_WatchDog WatchDog_Timer(clk, rst, WatchDog_Enable, Counter_Out, WatchDog_TimeOut);

SSD_Router SSD_Routing_Module(Game_Level,GPwdLED,  userID , PWD ,Winner_Index, Winner_Level2_Tens, Winner_Level2_Units, Winner_Level3_Tens, Winner_Level3_Units, RNG1, RNG2, PlayerTensDisp, PlayerUnitsDisp, Digit_FirstRound, 
Digit_FirstRound, ScoreTens_Level2, ScoreUnits_Level2, ScoreTens_Level3, ScoreUnits_Level3, NumOut1, NumOut2, NumOut3, NumOut4, NumOut5, 
NumOut6, Encrypt_on1, Encrypt_on2, Encrypt_on3, Encrypt_on4,Encrypt_on5, Encrypt_on6);

OneSecond OneSecond_module(clk, rst, Timer_Enable, OneSecond);

digitTimer Timer_module(clk, rst, Timer_Tens_Digit, Timer_Units_Digit, Timer_Load, OneSecond, Timer_Tens_out, Timer_Units_out, Timer_TimeOut);

score_level3 score_level3_module(clk, rst, Clear_Score_Level3, sum_ones, sum_tens, PlayerTensIn, PlayerUnitsIn, RNG_Load_Final,RNG2_Load_Final, 
Player_Load_Final, ScoreTens_Level3, ScoreUnits_Level3, verifier_flag);


Verifier_level3 Verifier_level3_module( verifier_flag , SuccLev3LEDR, SuccLev3LEDG );

score_level2 score_level2_Module(clk, rst, Clear_Score_Level2, PlayerUnitsIn, RNG1, RNG_Load_Final,
 Player_Load, ScoreTens_Level2, ScoreUnits_Level2, SuccLev2LEDR, SuccLev2LEDG);


Adder adder_module(RNG1, RNG2, sum_ones, sum_tens);

LoadRegister_4bit Player_Tens_Load(Player_Load_Final, rst, clk, PlayerTensIn, PlayerTensDisp);
LoadRegister_4bit Player_Units_Load(Player_Load_Final, rst, clk, PlayerUnitsIn, PlayerUnitsDisp);

Button_Shaper Game_Button(Game_Load, clk, rst, Game_Control);
Button_Shaper Player_Button(Player_Load_in, clk, rst, Player_Load);

Random_Number_Generator RNG1_Module(clk, rst, RNG_Load_Final, RNG1);
Random_Number_Generator RNG2_Module(clk, rst, RNG2_Load_Final, RNG2);

Seven_segment_symbol SSD1(Timer_Tens_out, HEX7, 0);
Seven_segment_symbol SSD2(Timer_Units_out, HEX6, 0);
Seven_segment_symbol SSD3(NumOut1, HEX5, Encrypt_on1);
Seven_segment_symbol SSD4(NumOut2, HEX4, Encrypt_on2);
Seven_segment_symbol SSD5(NumOut3, HEX3, Encrypt_on3);
Seven_segment_symbol SSD6(NumOut4, HEX2, Encrypt_on4);
Seven_segment_symbol SSD7(NumOut5, HEX1, Encrypt_on5);
Seven_segment_symbol SSD8(NumOut6, HEX0, Encrypt_on6);

endmodule
