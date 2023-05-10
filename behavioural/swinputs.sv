module swinputs(
  input logic core_CLK,
  input logic core_nReset,
  input logic [7:0]  SW,
  input logic        SW9,
  input logic        KEY3,
  output logic [6:0] HEX4,
  output logic [6:0] HEX5,
  output logic [7:0] forkinput,
  output logic [7:0] crankinput
);

  seven_seg seg1(.data(SW[3:0]), .sevenseg(HEX4));
  seven_seg seg2(.data(SW[7:4]), .sevenseg(HEX5));
  
  always_ff @(posedge core_CLK, negedge core_nReset) begin
    if (!core_nReset) begin
	   forkinput <= 8'd0;
		crankinput <= 8'd0;
	 end
	 else begin
	   if (!KEY3) begin 
	     if (SW9)
		    forkinput <= SW;
		  else 
		    crankinput <= SW;
	   end
	 end
  end
endmodule