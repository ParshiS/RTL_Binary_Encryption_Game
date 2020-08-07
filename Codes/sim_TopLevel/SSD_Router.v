module SSD_Router(Level,password_auth, user_id, Password,index, RNG1, RNG2, PlayerTIn, PlayerUIn, FRndOrig, 
FRndEncryp, SRndEncryp, 
SRndOrig,SC_Tens_l2,SC_Units_l2,SC_Tens_l3,SC_Units_l3, NumOut1, NumOut2, NumOut3, NumOut4, NumOut5, NumOut6, 
Encrypt_on1, Encrypt_on2, Encrypt_on3, Encrypt_on4,Encrypt_on5, Encrypt_on6);
	
	input [2:0] Level;
	input password_auth;
	input [3:0] user_id, Password, RNG1, RNG2, PlayerTIn, PlayerUIn, FRndOrig, FRndEncryp, SRndEncryp, SRndOrig, SC_Tens_l2,SC_Units_l2,SC_Tens_l3,SC_Units_l3,index;
	output [3:0]  NumOut1, NumOut2, NumOut3, NumOut4,NumOut5, NumOut6 ;
	output  Encrypt_on1, Encrypt_on2, Encrypt_on3, Encrypt_on4,Encrypt_on5, Encrypt_on6 ;
	reg [3:0] NumOut1, NumOut2, NumOut3, NumOut4,NumOut5, NumOut6 ;
	reg Encrypt_on1, Encrypt_on2, Encrypt_on3, Encrypt_on4,Encrypt_on5, Encrypt_on6;

	always@(Level, password_auth,user_id, Password,index, RNG1, RNG2, PlayerTIn, PlayerUIn, FRndOrig, FRndEncryp, SRndEncryp, 
	SRndOrig, SC_Tens_l2,SC_Units_l2,SC_Tens_l3,SC_Units_l3)
		begin
		if(password_auth==0)
		begin
		NumOut1=Password; Encrypt_on1 = 0;
		NumOut2=user_id; Encrypt_on2 = 0;
		NumOut3=4'b1111; Encrypt_on3 = 1;
		NumOut4=4'b1111; Encrypt_on4 = 1;
		NumOut5=4'b1111; Encrypt_on5 = 1;
		NumOut6=4'b1111; Encrypt_on6 = 1;
		end
		else
		begin
			case(Level)
				1: begin
					NumOut1=Password; Encrypt_on1 = 0;
					NumOut2=FRndOrig; Encrypt_on2 = 0;
					NumOut3=FRndEncryp; Encrypt_on3 = 1;
					NumOut4=4'b1111; Encrypt_on4 = 1;
					NumOut5=4'b1111; Encrypt_on5 = 1;
					NumOut6=4'b1111; Encrypt_on6 = 1;
				   end
				2: begin
					NumOut1=Password; Encrypt_on1 = 0;
					NumOut2=SRndOrig; Encrypt_on2 = 0;
					NumOut3=SRndEncryp; Encrypt_on3 = 1;
					NumOut4=4'b1111; Encrypt_on4 = 1;	
                 	NumOut5=SC_Tens_l2; Encrypt_on5 = 0;
					NumOut6=SC_Units_l2; Encrypt_on6 = 0;				
				   end
				3: begin
					NumOut1=RNG1; Encrypt_on1 = 1;
					NumOut2=RNG2; Encrypt_on2 = 1;
					NumOut3=PlayerTIn; Encrypt_on3 = 1;
					NumOut4=PlayerUIn; Encrypt_on4 = 1;		
					NumOut5=SC_Tens_l3; Encrypt_on5 = 0;
					NumOut6=SC_Units_l3; Encrypt_on6 = 0;
					end
				4:begin
					NumOut1=4'b1111; Encrypt_on1 = 1;
					NumOut2=index; Encrypt_on2 = 0;
					NumOut3=SC_Tens_l2; Encrypt_on3 = 0;
					NumOut4=SC_Units_l2; Encrypt_on4 = 0;		
					NumOut5=SC_Tens_l3; Encrypt_on5 = 0;
					NumOut6=SC_Units_l3; Encrypt_on6 = 0;				
				
				   end
				default: begin
					NumOut1=Password; Encrypt_on1 = 0;
					NumOut2=4'b1111; Encrypt_on2 = 1;
					NumOut3=4'b1111; Encrypt_on3 = 1;
					NumOut4=4'b1111; Encrypt_on4 = 1;	
					NumOut5=4'b1111; Encrypt_on5 = 1;
					NumOut6=4'b1111; Encrypt_on6 = 1;					
				   	 end
			endcase
		end
	end

endmodule

