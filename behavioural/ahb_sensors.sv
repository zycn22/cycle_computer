// This module is an AHB-Lite Slave containing three read-only locations
//
// Number of addressable locations : 5
// Size of each addressable location : 32 bits
// Supported transfer sizes : Word
// Alignment of base address : Double Word aligned
//
// Address map :
//   Base address + 0 : 
//     Sensors[0] (nFork)
//   Base address + 4 : 
//     Sensors[1] (nCrank)
//   Base address + 8 :
//     fork_cnt
//   Base address + 12 :
//     pedal_cnt



module ahb_sensors(

  // AHB Global Signals
  input HCLK,
  input HRESETn,

  // AHB Signals from Master to Slave
  input [31:0] HADDR, // With this interface only HADDR[3:2] is used (other bits are ignored)
  input [31:0] HWDATA,
  input [2:0] HSIZE,
  input [1:0] HTRANS,
  input HWRITE,
  input HREADY,
  input HSEL,

  // AHB Signals from Slave to Master
  output logic [31:0] HRDATA,
  output HREADYOUT,

  //Non-AHB Signals
  input nFork, nCrank

);

timeunit 1ns;
timeprecision 100ps;

  // AHB transfer codes needed in this module
  localparam No_Transfer = 2'b0;

  //how much time the fork/crank will be considered stopped
  localparam threshold = 32'h00010000;  // 4 seconds * 32768

  //localparam smoothfactor = 4'd2;
  // Storage for two different sensors
  logic [1:0] Sensors;
  logic [31:0] fork_cnt_temp, pedal_cnt_temp;
  logic [31:0] fork_cnt, pedal_cnt;    // <----------------only used 17 bits actually
  //logic [31:0] fork_cnt_last1, fork_cnt_last2;
  //logic loadforkcnt;
  //logic loadforklast;
  //logic [31:0] timer;
   
  // Storage for status bits 
  //logic [1:0] DataValid;

  // last_sensors is used for simple edge detection  
  logic [1:0] last_sensors;

  //control signals are stored in registers
  logic read_enable, write_enable;
  logic [1:0] word_address;


// detect the sensors signals
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        Sensors <= 2'b11;
        last_sensors <= 2'b11;
        fork_cnt <= '0;
        pedal_cnt <= '0;
        fork_cnt_temp <= '0;
     // timer <= 32'h0257F3CF;    // 20 minutes
        //timer <= '0;
        pedal_cnt_temp <= '0;
       // DataValid <= '0;
        //fork_cnt_last1 <= '0;
        //fork_cnt_last2 <= '0;
        //loadforkcnt <= 0;
        //loadforklast <= '0;
      end
    else
      begin
       // if (write_enable && (word_address==4))
         // timer <= HWDATA;

    //-------------------------------------------------Fork-----------------------------------
        if ( !nFork && last_sensors[0] )
          begin
            fork_cnt_temp <= 32'd0;

            if (fork_cnt_temp != 32'hFFFFFFFF) begin
              fork_cnt <= fork_cnt_temp;
              //fork_cnt_last1 <= fork_cnt_last1 >> smoothfactor;
              //fork_cnt_last2 <= fork_cnt_last1;
              //fork_cnt_temp <= fork_cnt_temp >> smoothfactor;
            end
           // if ((fork_cnt_temp != 32'hFFFFFFFF) && !write_enable)
             // timer <= timer + fork_cnt_temp;
            //loadforkcnt <= 1'b1;
            //DataValid[0] <= 1'b1;
            Sensors[0] <= 0;
          end    
        else begin

          if ( read_enable && ( word_address == 0 ) ) begin
            //DataValid[0] <= '0;
            Sensors[0] <= 1'b1;
          end

          if (fork_cnt_temp > threshold) 
            fork_cnt_temp <= 32'hFFFFFFFF;
          else 
            fork_cnt_temp <= fork_cnt_temp + 1'b1;

          if (fork_cnt_temp == 32'hFFFFFFFF)
            fork_cnt <= '0;
          
          //if (loadforkcnt) begin
            //if (fork_cnt_temp != 32'hFFFFFFFF)
              //fork_cnt <= fork_cnt_last2 + fork_cnt_temp - fork_cnt_last1;
            //fork_cnt_temp <= '0;
            //loadforkcnt <= '0;
            //loadforklast <= 1'b1;
          //end
     
          //if (loadforklast) begin
            //fork_cnt_last1 <= fork_cnt;
            //loadforklast <= '0;
          //end

        end
          

    //----------------------------------------------Crank-------------------------------------
        if ( !nCrank && last_sensors[1] )
          begin
            pedal_cnt_temp <= '0;

            if (pedal_cnt_temp != 32'hFFFFFFFF)
              pedal_cnt <= pedal_cnt_temp;
            //DataValid[1] <= 1'b1;
            Sensors[1] <= 0;
          end
        else begin

          if ( read_enable && ( word_address == 1 ) ) begin
            //DataValid[1] <= 0;
            Sensors[1] <= 1'b1;
          end


          if (pedal_cnt_temp > threshold) 
            pedal_cnt_temp <= 32'hFFFFFFFF;
          else 
            pedal_cnt_temp <= pedal_cnt_temp + 1'b1;

          if (pedal_cnt_temp == 32'hFFFFFFFF)
            pedal_cnt <= '0;
        end

        last_sensors <= {nCrank, nFork};

      end

  //Generate the control signals in the address phase
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        read_enable <= '0;
        write_enable <= '0;
        word_address <= '0;
      end
    else if ( HREADY && HSEL && (HTRANS != No_Transfer) )
      begin
        read_enable <= ! HWRITE;
        write_enable <= HWRITE;
        word_address <= HADDR[3:2];
     end
    else
      begin
        read_enable <= '0;
        write_enable <= '0;
        word_address <= '0;
     end

  //assign Status = {30'd0, DataValid};

  // read
  always_comb
    if ( ! read_enable )
      // (output of zero when not enabled for read is not necessary
      //  but may help with debugging)
      HRDATA = '0;
    else
      case (word_address)
        0 : HRDATA = {31'd0,Sensors[0]};
        1 : HRDATA = {31'd0,Sensors[1]};
        2 : HRDATA = fork_cnt;
        3 : HRDATA = pedal_cnt;
        //4 : HRDATA = timer;
        // unused address - returns zero
        default : HRDATA = '0;
      endcase


  //Transfer Response
  assign HREADYOUT = '1; //Single cycle Write & Read. Zero Wait state operations

 




endmodule

