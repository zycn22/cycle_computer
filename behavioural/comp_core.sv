


module comp_core(

  input HCLK, HRESETn,
  
  input nMode, nTrip,
  input nFork, nCrank,
//  
  output SegA, SegB, SegC, SegD, SegE, SegF, SegG, DP,
  output [3:0] nDigit,

  output LOCKUP

);
 
timeunit 1ns;
timeprecision 100ps;

  // Global & Master AHB Signals
  wire [31:0] HADDR, HWDATA, HRDATA;
  wire [1:0] HTRANS;
  wire [2:0] HSIZE, HBURST;
  wire [3:0] HPROT;
  wire HWRITE, HMASTLOCK, HRESP, HREADY;

  // Per-Slave AHB Signals
  wire HSEL_LED, HSEL_SENSORS, HSEL_BUTTONS, HSEL_RAM, HSEL_ROM;
  wire [31:0] HRDATA_ROM, HRDATA_RAM, HRDATA_BUTTONS, HRDATA_SENSORS, HRDATA_LED;
  wire HREADYOUT_ROM, HREADYOUT_RAM, HREADYOUT_BUTTONS, HREADYOUT_SENSORS, HREADYOUT_LED;

  // Non-AHB M0 Signals
  wire TXEV, RXEV, SLEEPING, SYSRESETREQ, NMI;
  wire [15:0] IRQ;

  
  // Set this to zero because simple slaves do not generate errors
  assign HRESP = '0;

  // Set all interrupt and event inputs to zero (unused in this design) 
  assign NMI = '0;
  assign IRQ = {16'b0000_0000_0000_0000};
  assign RXEV = '0;

  // Coretex M0 DesignStart is AHB Master
  CORTEXM0DS m0_1 (

    // AHB Signals
    .HCLK, .HRESETn,
    .HADDR, .HBURST, .HMASTLOCK, .HPROT, .HSIZE, .HTRANS, .HWDATA, .HWRITE,
    .HRDATA, .HREADY, .HRESP,                                   

    // Non-AHB Signals
    .NMI, .IRQ, .TXEV, .RXEV, .LOCKUP, .SYSRESETREQ, .SLEEPING

  );


  // AHB interconnect including address decoder, register and multiplexer
  ahb_interconnect interconnect_1 (

    .HCLK, .HRESETn, .HADDR, .HRDATA, .HREADY,

    .HSEL_SIGNALS({HSEL_LED,HSEL_SENSORS,HSEL_BUTTONS,HSEL_RAM,HSEL_ROM}),
    .HRDATA_SIGNALS({HRDATA_LED,HRDATA_SENSORS,HRDATA_BUTTONS,HRDATA_RAM,HRDATA_ROM}),
    .HREADYOUT_SIGNALS({HREADYOUT_LED,HREADYOUT_SENSORS,HREADYOUT_BUTTONS,HREADYOUT_RAM,HREADYOUT_ROM})

  );


  // AHBLite Slaves
        
  ahb_rom rom_1 (

    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_ROM),
    .HRDATA(HRDATA_ROM), .HREADYOUT(HREADYOUT_ROM)

  );

  ahb_ram ram_1 (

    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_RAM),
    .HRDATA(HRDATA_RAM), .HREADYOUT(HREADYOUT_RAM)
  );

//  sram ram_1 (
//      .HSEL(HSEL_RAM), .HRESETn, .HADDR, .HWDATA, .HWRITE, .HREADY, .HTRANS, 
//      .HRDATA(HRDATA_RAM)
//  );

  ahb_buttons buttons_1 (

    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_BUTTONS),
    .HRDATA(HRDATA_BUTTONS), .HREADYOUT(HREADYOUT_BUTTONS),

    .nMode(nMode), .nTrip(nTrip)

  );

  ahb_sensors sensors_1 (

    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_SENSORS),
    .HRDATA(HRDATA_SENSORS), .HREADYOUT(HREADYOUT_SENSORS),

    .nFork(nFork), .nCrank(nCrank)

  );

  ahb_seven_seg seven_seg_1 (

    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_LED),
    .HRDATA(HRDATA_LED), .HREADYOUT(HREADYOUT_LED),

    .segA(SegA), .segB(SegB), .segC(SegC), .segD(SegD), .segE(SegE), .segF(SegF), .segG(SegG), 
    .DP(DP),
    .nDigit(nDigit)

  );

endmodule
