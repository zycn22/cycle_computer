`timescale 1ns / 1ps
module nCrankgen (
  input [7:0] SW,
  input core_CLK,
  input core_nReset,
  output logic ncrank
);
  parameter n = 32768;
  localparam m = 196721;
  logic [23:0] count;
  logic [6:0] ncrank_timer; // Added a 7-bit counter for 65 time cycle duration
  logic [7:0] SW_prev; // Added to store previous SW value

  always_ff @(posedge core_CLK, negedge core_nReset) begin
    if (!core_nReset) begin
      count <= 0;
      ncrank_timer <= 0; // Reset ncrank_timer
		ncrank <= 1'b1;
    end
    else if (count == (m/SW) && (SW != 0)) begin
        ncrank <= 0;
        count <= 0;
        ncrank_timer <= 65; // Start ncrank_timer when ncrank goes low
      end
    else if (SW == 0) begin
        ncrank <= 1;
        count <= 0;
        ncrank_timer <= 0; // Reset ncrank_timer
      end
    else if (ncrank_timer > 0) begin // Added condition to control ncrank duration
        ncrank <= 0;
        ncrank_timer <= ncrank_timer - 1'b1;
      end
    else if (SW != SW_prev) begin
      count <= 0;
    end
    else begin
        ncrank <= 1;
        count <= count + 1'b1;
    end
  end
  
  always_ff @(posedge core_CLK, negedge core_nReset) begin
    if (!core_nReset) begin
	   SW_prev <= '0;
    end
	 else begin
	   SW_prev <= SW; // Update SW_prev at every clock cycle
	 end
  end
endmodule