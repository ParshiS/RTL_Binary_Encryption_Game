// ECE 5440/6370
// Final project
// Author: Ashwini Chaudhari, 8046
// Title: Seven segment Display
// Description: This module is about Seven Segment Display. Here depending upon Input signal, we will see symbol for each digit 0-9

// Add any log, design considerations, reasons for major changes etc.

module Seven_segment_symbol(Input_to_segment, output_from_segment, Encrypt_on);

   input [3:0]Input_to_segment;
   input Encrypt_on;
   output [6:0]output_from_segment;
   reg [6:0]output_from_segment;

   always @(Input_to_segment, Encrypt_on)
     begin
       if(Encrypt_on == 1)
	 begin 
          case(Input_to_segment)
           
                   4'b0000: begin output_from_segment = 7'b0101010; end  
                   4'b0001: begin output_from_segment = 7'b0001001; end
                   4'b0010: begin output_from_segment = 7'b0110110; end
                   4'b0011: begin output_from_segment = 7'b0110111; end
                   4'b0100: begin output_from_segment = 7'b1100100; end
                   4'b0101: begin output_from_segment = 7'b1000101; end
                   4'b0110: begin output_from_segment = 7'b0010101; end
                   4'b0111: begin output_from_segment = 7'b0111010; end
                   4'b1000: begin output_from_segment = 7'b1000000; end
                   4'b1001: begin output_from_segment = 7'b0000010; end
                   4'b1010: begin output_from_segment = 7'b1111111; end
                   4'b1011: begin output_from_segment = 7'b1111111; end
                   4'b1100: begin output_from_segment = 7'b1111111; end
                   4'b1101: begin output_from_segment = 7'b1111111; end
                   4'b1110: begin output_from_segment = 7'b1111111; end
                   4'b1111: begin output_from_segment = 7'b1111111; end
                   default: begin output_from_segment = 7'b1111111; end 
   
          endcase
	 end
       else
	 begin 
	  case(Input_to_segment)
	      4'b0000: begin output_from_segment = 7'b1000000; end
	      4'b0001: begin output_from_segment = 7'b1001111; end
	      4'b0010: begin output_from_segment = 7'b0100100; end
	      4'b0011: begin output_from_segment = 7'b0110000; end
	      4'b0100: begin output_from_segment = 7'b0011001; end
	      4'b0101: begin output_from_segment = 7'b0010010; end
	      4'b0110: begin output_from_segment = 7'b0000010; end
	      4'b0111: begin output_from_segment = 7'b1111000; end
	      4'b1000: begin output_from_segment = 7'b0000000; end
	      4'b1001: begin output_from_segment = 7'b0010000; end
	      4'b1010: begin output_from_segment = 7'b0001000; end
	      4'b1011: begin output_from_segment = 7'b0000011; end
	      4'b1100: begin output_from_segment = 7'b1000110; end
	      4'b1101: begin output_from_segment = 7'b0100001; end
	      4'b1110: begin output_from_segment = 7'b0000110; end
	      4'b1111: begin output_from_segment = 7'b0001110; end
	      default: begin output_from_segment = 7'b1111111; end
	  endcase
	 end
	
      end

endmodule
