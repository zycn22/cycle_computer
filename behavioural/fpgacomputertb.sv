`timescale 1ns/1ps
module fpgacomputer_tb();
    logic        CLK;
    logic        KEY0; //reset
    logic        KEY1; //Mode
    logic        KEY2; //Trip
    logic  [7:0] SW;   //Switches
    logic        SW9;  
    logic [6:0] HEX0; //digit[0]
    logic [6:0] HEX1; //digit[1]
    logic [6:0] HEX2; //digit[2]
    logic [6:0] HEX3; //digit[3]
    logic [6:0] HEX4; //speed_digit[0]
    logic [6:0] HEX5; //speed_digit[1]
    logic       LED3; //DP[0]
    logic       LED4; //DP[1]
    logic       LED5; //DP[2]
    logic       LED6; //DP[3]
    logic       LED9;  //LOCKUP

fpgacomputer dut1(.*);

initial begin
    CLK = 0;
    forever #10ns CLK = ~CLK;
end

initial begin
  KEY0 = 0;
  KEY1 = 1;
  KEY2 = 1;
  SW = 8'b0;
  SW9 = 1'b0;

  #1ms KEY0 = 1'b1;

  #1ms KEY1 = 1'b0;
  #5ms KEY1 = 1'b1;

  #5ms KEY1 = 1'b0;
  #5ms KEY1 = 1'b1;

  #5ms KEY1 = 1'b0;
  #5ms KEY1 = 1'b1;

  #10ms SW = 8'd3;
  #200ms  SW9 = 1'd1;
  #2s SW = 8'd0;
  #3s $stop;
end
endmodule