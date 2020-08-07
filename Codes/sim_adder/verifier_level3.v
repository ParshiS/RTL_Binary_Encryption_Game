module Verifier_level3( verifier , ledr_out , ledg_out );//verifier_flag = verifier

  input verifier;
  output ledr_out , ledg_out;
  reg ledr_out , ledg_out;

  always @ (verifier)
    begin
  if(verifier==1)
        begin
          ledr_out = 1'b0;		// red led turns off
          ledg_out = 1'b1;		// green led turns on
        end
      else
	begin
          ledr_out = 1'b1;
          ledg_out = 1'b0;
        end
    end
endmodule
