module fpgacomputer(
  input logic        CLK,
  input logic        KEY0, //reset
  input logic        KEY1, //Mode
  input logic        KEY2, //Trip
  input logic        KEY3,
  input logic  [7:0] SW,   //Switches
  input logic        SW9,  
  output logic [6:0] HEX0, //digit[0]
  output logic [6:0] HEX1, //digit[1]
  output logic [6:0] HEX2, //digit[2]
  output logic [6:0] HEX3, //digit[3]
  output logic [6:0] HEX4, //speed_digit[0]
  output logic [6:0] HEX5, //speed_digit[1]
  output logic       LED3, //DP[0]
  output logic       LED4, //DP[1]
  output logic       LED5, //DP[2]
  output logic       LED6, //DP[3]
  output logic       LED9  //LOCKUP
);
  
  logic sync_nReset_1, sync_nReset_2;
  logic sync_nMode_1, sync_nMode_2;
  logic sync_nTrip_1, sync_nTrip_2;
  logic core_nReset;
  logic core_nMode, core_nTrip;
  logic core_CLK;
  
  wire nFork, nCrank;
  wire SegA, SegB, SegC, SegD, SegE, SegF, SegG, DP;
  wire [7:0] forkinput, crankinput;
  wire [3:0] nDigit;
  
  assign core_nReset = sync_nReset_2;
  assign core_nMode = sync_nMode_2;
  assign core_nTrip = sync_nTrip_2;
  
  always_ff @(posedge CLK, negedge KEY0) begin
    if(!KEY0) begin
	   sync_nReset_1 <= 1'b0;
		sync_nReset_2 <= 1'b0;
	 end
	 else begin
	   sync_nReset_1 <= 1'b1;
		sync_nReset_2 <= sync_nReset_1;
	 end
  end
  
  always_ff @(posedge core_CLK, negedge core_nReset) begin
    if(!core_nReset) begin
	   sync_nMode_1 <= 1'b1;
		sync_nMode_2 <= 1'b1;
		
		sync_nTrip_1 <= 1'b1;
		sync_nTrip_2 <= 1'b1;
	 end
	 else begin
	   sync_nMode_1 <= KEY1;
		sync_nMode_2 <= sync_nMode_1;
		sync_nTrip_1 <= KEY2;
		sync_nTrip_2 <= sync_nTrip_1;
	 end
  end
  
  low_clk   clk1(.CLK(CLK), .core_nReset(core_nReset), .core_CLK(core_CLK));
  
  LEDdisplay led1(.SegA, .SegB, .SegC, .SegD, .SegE, .SegF, .SegG, .DP,
                  .nDigit, .HEX0, .HEX1, .HEX2, .HEX3, .LED3, .LED4, .LED5, .LED6);
						
  swinputs   sw1(.KEY3, .core_CLK, .core_nReset, .SW9, .SW(SW), .HEX4(HEX4), .HEX5(HEX5), .forkinput, .crankinput);
  
  nForkgen forkgen1(.SW(forkinput), .core_CLK, .core_nReset, .nfork(nFork));
  nCrankgen crankgen1(.SW(crankinput), .core_CLK, .core_nReset, .ncrank(nCrank));

  comp_core core1(.HCLK(core_CLK), .HRESETn(core_nReset), .nMode(core_nMode), .nTrip(core_nTrip), .LOCKUP(LED9),
                  .nFork, .nCrank, .SegA, .SegB, .SegC, .SegD, .SegE, .SegF, .SegG, .DP, .nDigit);
  
  
  
endmodule