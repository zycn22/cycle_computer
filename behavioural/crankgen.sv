module crankgen(
  input logic core_CLK,
  input logic core_nReset,
  input logic [7:0] SW,
  output logic nCrank,
);

  enum logic [1:0] {idle, count1, count2} state;
  
  logic [15:0] counter;
  logic [7:0]  crank_counter;
  logic [15:0] c;
  
  always_ff @(posedge core_CLK, negedge core_nReset) begin
    if (!core_nReset) begin
	   counter <= '0;
		crank_counter <= '0;
		nCrank <= '0;
	 end
	 else begin
	   case (state)
		  idle: begin
		          c <= 1967213/(SW*10);
					 state <= count1;
				  end
				  
		  count1
		  
		endcase 
	 end
  end

endmodule