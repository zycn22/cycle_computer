module LEDdisplay(
  input logic SegA, SegB, SegC, SegD, SegE, SegF, SegG, DP,
  input logic [3:0] nDigit,
  output logic [6:0] HEX0,
  output logic [6:0] HEX1,
  output logic [6:0] HEX2,
  output logic [6:0] HEX3,
  output logic LED3, LED4, LED5, LED6
);

  always_comb begin
    HEX0 = 7'b1111111;
	 HEX1 = 7'b1111111;
	 HEX2 = 7'b1111111;
	 HEX3 = 7'b1111111;
	 LED3 = 1'b0;
	 LED4 = 1'b0;
	 LED5 = 1'b0;
	 LED6 = 1'b0;
	 case (nDigit) 
	   4'b1110: begin 
		           HEX0 = ~{SegG, SegF, SegE, SegD, SegC, SegB, SegA};
					  LED3 = DP;
					end
	   
		4'b1101: begin
		           HEX1 = ~{SegG, SegF, SegE, SegD, SegC, SegB, SegA};
					  LED4 = DP;
					end
					
	   4'b1011: begin
		           HEX2 = ~{SegG, SegF, SegE, SegD, SegC, SegB, SegA};
					  LED5 = DP;
					end
					
		4'b0111: begin
		           HEX3 = ~{SegG, SegF, SegE, SegD, SegC, SegB, SegA};
					  LED6 = DP;
					end
	 endcase
  end

endmodule