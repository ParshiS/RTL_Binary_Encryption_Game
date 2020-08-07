module OneMilliSec (clk, rst, enable, OneMilliSec);

input clk, rst, enable;
output reg OneMilliSec;

reg [15:0] LFSR;
wire Feedback = LFSR[15];

	always @ (posedge clk)
	begin
		if(rst == 0)
		begin
			LFSR <= 16'b1111111111111111; 
			OneMilliSec<=0;
		end
		
		else
		begin
			if (enable == 1)
			begin
	     			 LFSR[0] <= Feedback;
 				 LFSR[1] <= LFSR[0];
   				 LFSR[2] <= LFSR[1] ^ Feedback;
   				 LFSR[3] <= LFSR[2] ^ Feedback;
   				 LFSR[4] <= LFSR[3];
   				 LFSR[5] <= LFSR[4] ^ Feedback;
   				 LFSR[6] <= LFSR[5];
   				 LFSR[7] <= LFSR[6];
    				 LFSR[8] <= LFSR[7];
    				 LFSR[9] <= LFSR[8];
    				 LFSR[10] <= LFSR[9];
    				 LFSR[11] <= LFSR[10];
    				 LFSR[12] <= LFSR[11];
    				 LFSR[13] <= LFSR[12];
    				 LFSR[14] <= LFSR[13];
   				 LFSR[15] <= LFSR[14];

					if (LFSR == 16'b1101101101101100)
					begin
						OneMilliSec<=1;
					        LFSR <= 16'b1111111111111111; 
					end
					
					else
					begin
						OneMilliSec<=0;
					end
			end
		end
	end
endmodule

