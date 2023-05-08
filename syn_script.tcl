#############################################################
# This is the .tcl file for synthesis of wrap_cycle_computer #
#############################################################

  analyze -format sv "../behavioural/computer.sv ../behavioural/comp_core.sv ../behavioural/ahb_buttons.sv ../behavioural/ahb_interconnect.sv ../behavioural/ahb_sensors.sv ../behavioural/ahb_seven_seg.sv ../behavioural/cortexm0ds_logic.sv ../behavioural/CORTEXM0DS.sv ../behavioural/ahb_ram.sv ../behavioural/ahb_rom.sv"

#analyze -format sv "../behavioural/wrap_cycle_computer.sv ../behavioural/arm_soc_cycle_computer.sv ../behavioural/ahb_buttons.sv ../behavioural/ahb_interconnect.sv ../behavioural/ahb_sensors.sv ../behavioural/ahb_seven_seg.sv ../behavioural/cortexm0ds_logic.sv ../behavioural/CORTEXM0DS.sv ../behavioural/ahb_rom.sv ../behavioural/sram.sv"

  elaborate computer

  change_selection computer

  source constraints.sdc

  check_timing

##---------------------------   FIX HOLD TIME VIOLATION   ----------------------------
  set_fix_hold master_clock
  set_dont_touch [get_cells RESET_SYNC_FF*]

##------------------------------   FLATTEN DESIGN    ---------------------------------
  current_design computer
  ungroup -all -flatten

##-------------------------    SPECIFIC IMPLAMENTATION    ----------------------------
  #set_implementation <implementation_type> <cell_list>

##--------------------------------   COMPILE    --------------------------------------
  #compile
  #compile -scan
  compile_ultra -scan
  #compile -scan -map_effort high -incremental_mapping

##----------------------------    REGISTER BALANCING    ------------------------------
  optimize_registers

##----------------------------------   DFT    ----------------------------------------
 ##specifying ports
  set_dft_signal -view existing_dft -type ScanClock   -port Clock        -timing {45 60}
  set_dft_signal -view existing_dft -type Reset       -port nReset       -active_state 0

  set_dft_signal -view spec         -type TestMode    -port Test         -active_state 1
  set_dft_signal -view spec         -type ScanEnable  -port ScanEnable   -active_state 1
  set_dft_signal -view spec         -type ScanDataIn  -port SDI 
  set_dft_signal -view spec         -type ScanDataOut -port SDO 

    ##fix violations relating to set/reset
    set_dft_configuration -fix_reset enable
    set_autofix_configuration -type reset -method mux -control Test -test_data nReset

    set_dft_configuration -fix_set enable
    set_autofix_configuration -type set -method mux -control Test -test_data nReset

 ##create test protocol
  create_test_protocol

 ##check for design rule violation
  dft_drc

 ##scan path insertion
  set_scan_configuration -chain_count 1
  preview_dft

  insert_dft
  dft_drc

##----------------------------    Design Analysis    ---------------------------------
  report_qor
  report_power
  report_timing
  report_clock_gating
  
 ##save reports
  report_area > synth_area.rpt
  report_power > synth_power.rpt
  report_timing > synth_timing.rpt

##------------------------------    Save Design    -----------------------------------
  report_names -rules verilog
  change_names -rules verilog -hierarchy -verbose
  
  write -f verilog -hierarchy -output "../gate_level/computer.v"
  write_sdc "../constraints/computer.sdc"
  write_sdf "../gate_level/computer.sdf"

