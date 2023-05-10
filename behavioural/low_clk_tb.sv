module low_clk_tb();

  logic CLK, core_nReset;
  logic core_CLK;
  low_clk inst1(.*);

  initial begin
    CLK = 0;
    forever #10 CLK = ~CLK;
  end

  initial begin
    core_nReset = 0;
    #50 core_nReset = 1;
    #3s $stop;
  end
endmodule