// This module is an AHB-Lite Slave containing two read-only locations
//
// Number of addressable locations : 2
// Size of each addressable location : 32 bits
// Supported transfer sizes : Word
// Alignment of base address : Double Word aligned
//
// Address map :
//   Base address + 0 : 
//     Read nMode
//   Base address + 4 : 
//     Read nTrip
//   Base address + 8 :
//     Read together_button



module ahb_buttons(

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
  input nMode, nTrip

);

timeunit 1ns;
timeprecision 100ps;

  // AHB transfer codes needed in this module
  localparam No_Transfer = 2'b0;
  localparam TIME_25MS = 10'b1010011110;
  localparam TIME_30MS = 12'h3D7;

  // button debouncing counter
  logic [19:0] debouncing_cnt;
  logic key_cnt;
  logic [19:0] debouncing_cnt1;
  logic key_cnt1;

//  together button 
  logic [19:0] together_count;
  //logic together_cnt;
  logic together_button;
  logic together_temp;

  // logic for button debouncing
  logic mode, trip;
  logic [1:0] Buttons;
  logic [1:0] last_buttons;


  //control signals are stored in registers
  logic read_enable;
  logic [1:0] word_address;

//----------------------------------------------Button1  Debouncing--------------------------------------------
  
  always_ff @(posedge HCLK, negedge HRESETn) 
    if ( ! HRESETn )
	begin
      mode <= 1'b1;
	end
    else if (debouncing_cnt == TIME_25MS - 1)
	begin
      mode <= nMode;
        end

  
  always_ff @(posedge HCLK, negedge HRESETn) 
    if ( ! HRESETn )
	begin
        debouncing_cnt <= '0;
	end
    else if (key_cnt) 
	begin
        debouncing_cnt <= debouncing_cnt + 1'b1;
	end
    else
	begin
        debouncing_cnt <= '0;
   	end

  always_ff @(posedge HCLK, negedge HRESETn) 
    if ( ! HRESETn )
	begin
        key_cnt <= '0;
	end
    else if (debouncing_cnt == 0 && nMode!=mode) 
	begin
        key_cnt <= '1;
	end
    else if(debouncing_cnt == TIME_25MS - 1)
	begin
        key_cnt <= '0;
    	end
//----------------------------------------------Button2 Debouncing--------------------------------------------
always_ff @(posedge HCLK, negedge HRESETn) 
    if ( ! HRESETn )
	begin
      trip <= 1'b1;
	end
    else if (debouncing_cnt1 == TIME_25MS - 1)
	begin
      trip <= nTrip;
        end

  // generate counter
  always_ff @(posedge HCLK, negedge HRESETn) 
    if ( ! HRESETn )
	begin
        debouncing_cnt1 <= '0;
	end
    else if (key_cnt1) 
	begin
        debouncing_cnt1 <= debouncing_cnt1 + 1'b1;
	end
    else
	begin
        debouncing_cnt1 <= '0;
   	end

  always_ff @(posedge HCLK, negedge HRESETn) 
    if ( ! HRESETn )
	begin
        key_cnt1 <= '0;
	end
    else if (debouncing_cnt1 == 0 && nTrip!=trip) 
	begin
        key_cnt1 <= '1;
	end
    else if(debouncing_cnt1 == TIME_25MS - 1)
	begin
        key_cnt1 <= '0;
    	end
// ---------------------------------------Single rise edge detection------------------------------------------

  always_ff @(posedge HCLK, negedge HRESETn) begin
     if ( ! HRESETn ) begin
       last_buttons <= 2'b11;
       Buttons <= 2'b11;
     end
     else begin

       last_buttons <= {trip,mode};
       
    // nMode single edge trigger
       if ( mode && !last_buttons[0] && !together_temp) begin 
         Buttons[0] <= 1'b0;
       end
       else begin
         if ( read_enable && ( word_address == 0)  ) begin
           Buttons[0] <= 1'b1;
         end
       end

    // nTirp single edge trigger
       if ( trip && !last_buttons[1] && !together_temp) begin 
         Buttons[1] <= 1'b0;
       end
       else begin
         if ( read_enable && ( word_address == 1 )  ) begin
           Buttons[1] <= 1'b1;
         end
       end




     end
  end 

//----------------------------------------------together Button--------------------------------------------



 always_ff @(posedge HCLK, negedge HRESETn)
        if ( ! HRESETn ) begin
          together_count <= 0;
	end
        else if (!last_buttons[0] & !last_buttons[1]) begin
	  together_count <= together_count + 1'b1;
	end
	else begin
	  together_count <= '0;
	end

  always_ff @(posedge HCLK, negedge HRESETn)
        if ( ! HRESETn ) begin
          together_temp <= 0;
          together_button <= '0;
	end
        else  begin  
         
          if(together_count == TIME_30MS) begin
	    together_temp <= 1'b1;
          end

          if (read_enable && (word_address == 2) ) begin
            together_button <= '0;
          end
          else begin
            if ( mode && !last_buttons[0] && last_buttons[1] && together_temp) begin
              together_button <= 1'b1;
              together_temp <= '0;
            end 

            if (trip && !last_buttons[1] && last_buttons[0] && together_temp) begin
              together_button <= 1'b1;
              together_temp <= '0;
            end
          end

	end  
        


//------------------------------------------------------------------------------------------------------------

  //Generate the control signals in the address phase
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        read_enable <= '0;
        word_address <= '0;
      end
    else if ( HREADY && HSEL && (HTRANS != No_Transfer) )
      begin
        read_enable <= ! HWRITE;
        word_address <= HADDR[3:2];
     end
    else
      begin
        read_enable <= '0;
        word_address <= '0;
     end


  // read
  always_comb
    if ( ! read_enable )
      // (output of zero when not enabled for read is not necessary
      //  but may help with debugging)
      HRDATA = '0;
    else
      case (word_address)
        0 : HRDATA = Buttons[0];
        1 : HRDATA = Buttons[1];
        2 : HRDATA = together_button;
        // unused address - returns zero
        default : HRDATA = '0;
      endcase

  //Transfer Response
  assign HREADYOUT = '1; //Single cycle Write & Read. Zero Wait state operations



endmodule


