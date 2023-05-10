module low_clk(
  input logic CLK,
  input logic core_nReset,
  output logic core_CLK
);

  logic [10:0] counter;
  
  always_ff @(posedge CLK, negedge core_nReset)begin
    if(!core_nReset) begin
	   counter <= '0;
		core_CLK <= '0;
	 end
	 else begin
	   if (counter != 11'd1526) begin    //1526 
	     counter <= counter + 1'b1;
		  core_CLK <= '0;
		end
		else begin
		  counter <= '0;
		  core_CLK <= 1'b1;
		end
	 end
  end
  
endmodule