module Count1000_WatchDog(clk,rst,count, WatchDogEnable, out);
input clk,rst,count,WatchDogEnable;
output reg out;
reg [9:0] counter;

	always@(posedge clk)
	begin
	
		if(rst==0)
			begin
	
				out<=0;
				counter<=0;

			end

		else
			begin
				if(WatchDogEnable==1)
				begin

					if(count==1)
					begin
						
							if(counter>=999)
							begin
								out<=1;
								counter<=0;
							end
							else
							begin
								counter<=counter+1;
								out<=0;
							end
					end
					else
					begin
					
						out<=0;
					end
				
				end
				else
				begin
					counter<=0;
					out<=0;
				end
			end
	end
endmodule

