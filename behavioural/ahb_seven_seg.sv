
// This module is an AHB-Lite 7-segment display Slave
//
// Number of addressable locations : 3
// Size of each addressable location : 32 bits
// Supported transfer sizes : Word
// Alignment of base address : Word aligned
//
// Address map :
//   Base addess + 0 :  
//     Write ouput port (seven_seg) register : [31:18]   [17:15]   [14:12]     [11:8]     [7:4]      [3:0]
//                                                '0       dp      digit3      digit2     digit1     digit0


module ahb_seven_seg(

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
  output logic segA, segB, segC, segD, segE, segF, segG,
  output logic DP,
  output logic [3:0] nDigit

);

timeunit 1ns;
timeprecision 100ps;

  // AHB transfer codes needed in this module
  localparam No_Transfer = 2'b0;

  //  output registers
  logic [31:0] seven_seg;
  logic [7:0] digit3, digit2, digit1, digit0;
  
  //control signals are stored in registers
  logic write_enable, read_enable;
  logic [1:0] word_address;


// ----------------------- decoder ----------------------------

 //mode character
  always_comb begin
    digit3 = '0;
    case (seven_seg[14:12])
      3'd0: begin digit3 = 8'b01111010; end  // d  for distance
      3'd1: begin digit3 = 8'b00011110; end  // t  for timer
      3'd2: begin digit3 = 8'b00110000; end  // v  for speed
      3'd3: begin digit3 = 8'b00011010; end  // c  for cadence
      3'd4: begin digit3 = 8'b11111010; end  // a  for average speed
      3'd5: begin digit3 = 8'b10110110; end  // s  for maximum speed
      3'd6: begin digit3 = 8'b01111000; end  // j  for calorie
      3'd7: begin digit3 = 8'b00000000; end  // settings mode, no leading character
      default: begin digit3 = 8'b10011110;  end //error state 
    endcase
  end

  always_comb begin
    digit2 = '0;
    digit2[0] = seven_seg[17];
    case (seven_seg[11:8])
      4'd0: begin digit2[7:1] = 7'b1111110; end
      4'd1: begin digit2[7:1] = 7'b0110000; end
      4'd2: begin digit2[7:1] = 7'b1101101; end
      4'd3: begin digit2[7:1] = 7'b1111001; end
      4'd4: begin digit2[7:1] = 7'b0110011; end
      4'd5: begin digit2[7:1] = 7'b1011011; end
      4'd6: begin digit2[7:1] = 7'b1011111; end
      4'd7: begin digit2[7:1] = 7'b1110000; end
      4'd8: begin digit2[7:1] = 7'b1111111; end
      4'd9: begin digit2[7:1] = 7'b1111011; end
      default: begin digit2[7:1] = 7'b1001111; end
    endcase 
  end

 
  always_comb begin
    digit1 = '0;
    digit1[0] = seven_seg[16];
    case (seven_seg[7:4])
      4'd0: begin digit1[7:1] = 7'b1111110; end
      4'd1: begin digit1[7:1] = 7'b0110000; end
      4'd2: begin digit1[7:1] = 7'b1101101; end
      4'd3: begin digit1[7:1] = 7'b1111001; end
      4'd4: begin digit1[7:1] = 7'b0110011; end
      4'd5: begin digit1[7:1] = 7'b1011011; end
      4'd6: begin digit1[7:1] = 7'b1011111; end
      4'd7: begin digit1[7:1] = 7'b1110000; end
      4'd8: begin digit1[7:1] = 7'b1111111; end
      4'd9: begin digit1[7:1] = 7'b1111011; end
      default: begin digit1[7:1] = 7'b1001111; end
    endcase 
  end

  always_comb begin
    digit0 = '0;
    digit0[0] = seven_seg[15];
    case (seven_seg[3:0])
      4'd0: begin digit0[7:1] = 7'b1111110; end
      4'd1: begin digit0[7:1] = 7'b0110000; end
      4'd2: begin digit0[7:1] = 7'b1101101; end
      4'd3: begin digit0[7:1] = 7'b1111001; end
      4'd4: begin digit0[7:1] = 7'b0110011; end
      4'd5: begin digit0[7:1] = 7'b1011011; end
      4'd6: begin digit0[7:1] = 7'b1011111; end
      4'd7: begin digit0[7:1] = 7'b1110000; end
      4'd8: begin digit0[7:1] = 7'b1111111; end
      4'd9: begin digit0[7:1] = 7'b1111011; end
      default: begin digit0[7:1] = 7'b1001111; end
    endcase 
  end



  always_ff @(posedge HCLK, negedge HRESETn) begin
    if ( ! HRESETn ) begin
      nDigit <= 4'b1110;
    end
    else begin
      if (nDigit == 4'b1110) nDigit <= 4'b1101;
      else if (nDigit == 4'b1101) nDigit <= 4'b1011;
      else if (nDigit == 4'b1011) nDigit <= 4'b0111;
      else if (nDigit == 4'b0111) nDigit <= 4'b1110;
    end
  end

  always_comb begin
    segA = '0;
    segB = '0;
    segC = '0;
    segD = '0;
    segE = '0;
    segF = '0;
    segG = '0;
    DP   = '0;
    case (nDigit)
      4'b1110: begin {segA, segB, segC, segD, segE, segF, segG, DP} = digit0; end
      4'b1101: begin {segA, segB, segC, segD, segE, segF, segG, DP} = digit1; end
      4'b1011: begin {segA, segB, segC, segD, segE, segF, segG, DP} = digit2; end
      4'b0111: begin {segA, segB, segC, segD, segE, segF, segG, DP} = digit3; end
    default: begin {segA, segB, segC, segD, segE, segF, segG, DP} = 8'b1001111; end
    endcase 
   end
// ------------------------------------------------------------

  //Generate the control signals in the address phase
  
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        write_enable <= '0;
        read_enable <= '0;
        word_address <= '0;
      end
    else if ( HREADY && HSEL && (HTRANS != No_Transfer) )
      begin
        write_enable <= HWRITE;
        read_enable <= !HWRITE;
        word_address <= HADDR[3:2];
     end
    else
      begin
        write_enable <= '0;
        read_enable <= '0;
        word_address <= '0;
     end

  // write
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        seven_seg <= '0;
      end
    else if ( write_enable && (word_address==0)) seven_seg <= HWDATA;


  //read
  always_comb
    if ( ! read_enable )
      HRDATA = '0;
    else
      HRDATA = seven_seg;

  //Transfer Response
  assign HREADYOUT = '1; //Single cycle Write & Read. Zero Wait state operations


endmodule

