// This special stimulus simulates a cycle journey with a gear change 

  // Hall-effect sensor stimulus
  //
  //  This default stimulus represents initial inactivity
  //  followed by pedalling at a constant rate for about 10 seconds 
  //  After this we go downhill - pedalling slower but travelling faster 


  initial
    begin
      Crank = 0;
      #1.05s
      repeat(20)
        #500ms -> trigger_crank_sensor; //0.5s/per total=10s
      #5s
      forever
        #1000ms -> trigger_crank_sensor;//0.1s/per
    end
  
  initial
    begin
      Fork = 0;
    forever begin
      #5s
      repeat(10)
        #1000ms -> trigger_fork_sensor;  //0.08s/per  total=72s
      repeat(9)
        #900ms -> trigger_fork_sensor;  //0.08s/per  total=72s
      repeat(8)
        #800ms -> trigger_fork_sensor;  //0.08s/per  total=72s
      repeat(7)
        #700ms -> trigger_fork_sensor;  //0.08s/per  total=72s
      repeat(6)
        #600ms -> trigger_fork_sensor;  //0.08s/per  total=72s
      repeat(5)
        #500ms -> trigger_fork_sensor;  //0.08s/per  total=72s
      repeat(40)
        #400ms -> trigger_fork_sensor;  //0.08s/per  total=72s
      repeat(3)
        #800ms -> trigger_fork_sensor;
      repeat(1)
        #1000ms -> trigger_fork_sensor;
    end
     
    end
  
  // Button stimulus
  //
  //  After about 5 seconds switch to speed display 

  initial
    begin
      Mode = 0;
      Trip = 0;
      mode_index = 0; 
     
      repeat(10)
        #10s  -> press_mode_button;       

      #2s  -> press_trip_button; 
        #50ms -> press_mode_button;
 
      #150ms  -> press_mode_button; 
      #80ms  -> press_trip_button; 

      repeat(8)
      #130ms  -> press_trip_button; 

      #130ms  -> press_mode_button; 
      repeat(6)
      #130ms  -> press_trip_button; 
    
      #130ms  -> press_mode_button;

      forever
      #10s  -> press_mode_button;
      
    end
  


  // Stimulus not changed for
  // Clock nReset and scan path signals 

  initial
    begin
      Test = 0;
      SDI = 0;
      ScanEnable = 0;
      nReset = 0;
      #(`clock_period / 4) nReset = 1;
    end

  initial
    begin
      Clock = 0;
      #`clock_period
      forever
        begin
          Clock = 1;
          #(`clock_period / 2) Clock = 0;
          #(`clock_period / 2) Clock = 0;
        end
    end

logic [7:0]leddigit;

  always_comb begin
    case ({SegA, SegB, SegC, SegD, SegE, SegF, SegG})
      7'b0111101: leddigit = 8'h64;
      7'b0001111: leddigit = 8'h74;
      7'b0011000: leddigit = 8'h76;
      7'b0001101: leddigit = 8'h63;
      7'b1111101: leddigit = 8'h61;
      7'b1011011: leddigit = 8'h73;
      7'b0111100: leddigit = 8'h6A;
      7'b0000000: leddigit = 8'h20;
      7'b1111110: leddigit = 8'h30;
      7'b0110000: leddigit = 8'h31;
      7'b1101101: leddigit = 8'h32;
      7'b1111001: leddigit = 8'h33;
      7'b0110011: leddigit = 8'h34;
      7'b1011011: leddigit = 8'h35;
      7'b1011111: leddigit = 8'h36;
      7'b1110000: leddigit = 8'h37;
      7'b1111111: leddigit = 8'h38;
      7'b1111011: leddigit = 8'h39;
      default: leddigit = 8'h65;
    endcase
  end

