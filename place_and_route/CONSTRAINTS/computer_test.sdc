###################################################################

# Created by write_sdc on Thu Apr 27 11:22:06 2023

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA
set_max_area 0
set_driving_cell -min -lib_cell BU1P  -pin PAD [get_ports \
nMode]
set_driving_cell -max -lib_cell BU24P  -pin PAD           \
[get_ports nMode]
set_driving_cell -min -lib_cell BU1P  -pin PAD [get_ports \
ScanEnable]
set_driving_cell -max -lib_cell BU24P  -pin PAD           \
[get_ports ScanEnable]
set_driving_cell -min -lib_cell BU1P  -pin PAD [get_ports \
nReset]
set_driving_cell -max -lib_cell BU24P  -pin PAD           \
[get_ports nReset]
set_driving_cell -min -lib_cell BU1P  -pin PAD [get_ports \
SDI]
set_driving_cell -max -lib_cell BU24P  -pin PAD           \
[get_ports SDI]
set_driving_cell -min -lib_cell BU1P  -pin PAD [get_ports \
Test]
set_driving_cell -max -lib_cell BU24P  -pin PAD           \
[get_ports Test]
set_driving_cell -min -lib_cell BU1P  -pin PAD [get_ports \
nCrank]
set_driving_cell -max -lib_cell BU24P  -pin PAD           \
[get_ports nCrank]
set_driving_cell -min -lib_cell BU1P  -pin PAD [get_ports \
nTrip]
set_driving_cell -max -lib_cell BU24P  -pin PAD           \
[get_ports nTrip]
set_driving_cell -min -lib_cell BU1P  -pin PAD [get_ports \
Clock]
set_driving_cell -max -lib_cell BU24P  -pin PAD           \
[get_ports Clock]
set_driving_cell -min -lib_cell BU1P  -pin PAD [get_ports \
nFork]
set_driving_cell -max -lib_cell BU24P  -pin PAD           \
[get_ports nFork]
set_load -pin_load 1 [get_ports {nDigit[3]}]
set_load -pin_load 1 [get_ports {nDigit[2]}]
set_load -pin_load 1 [get_ports {nDigit[1]}]
set_load -pin_load 1 [get_ports {nDigit[0]}]
set_load -pin_load 1 [get_ports SegF]
set_load -pin_load 1 [get_ports DP]
set_load -pin_load 1 [get_ports SegC]
set_load -pin_load 1 [get_ports SegE]
set_load -pin_load 1 [get_ports SegD]
set_load -pin_load 1 [get_ports SegA]
set_load -pin_load 1 [get_ports SDO]
set_load -pin_load 1 [get_ports SegB]
set_load -pin_load 1 [get_ports SegG]
set_load -min -pin_load 0.01 [get_ports {nDigit[3]}]
set_load -min -pin_load 0.01 [get_ports {nDigit[2]}]
set_load -min -pin_load 0.01 [get_ports {nDigit[1]}]
set_load -min -pin_load 0.01 [get_ports {nDigit[0]}]
set_load -min -pin_load 0.01 [get_ports SegF]
set_load -min -pin_load 0.01 [get_ports DP]
set_load -min -pin_load 0.01 [get_ports SegC]
set_load -min -pin_load 0.01 [get_ports SegE]
set_load -min -pin_load 0.01 [get_ports SegD]
set_load -min -pin_load 0.01 [get_ports SegA]
set_load -min -pin_load 0.01 [get_ports SDO]
set_load -min -pin_load 0.01 [get_ports SegB]
set_load -min -pin_load 0.01 [get_ports SegG]
create_clock [get_ports Clock]  -name master_clock  -period 3000  -waveform {0 1500}
set_clock_latency 2.5  [get_clocks master_clock]
set_clock_uncertainty 1  [get_clocks master_clock]
set_clock_transition -max -rise 0.5 [get_clocks master_clock]
set_clock_transition -max -fall 0.5 [get_clocks master_clock]
set_clock_transition -min -rise 0.5 [get_clocks master_clock]
set_clock_transition -min -fall 0.5 [get_clocks master_clock]
set_false_path   -from [get_ports nReset]
set_input_delay -clock master_clock  -max 12  -network_latency_included  [get_ports nReset]
set_input_delay -clock master_clock  -min 1  -network_latency_included  [get_ports nReset]
set_input_delay -clock master_clock  -max 12  -network_latency_included  [get_ports nMode]
set_input_delay -clock master_clock  -min 1  -network_latency_included  [get_ports nMode]
set_input_delay -clock master_clock  -max 12  -network_latency_included  [get_ports ScanEnable]
set_input_delay -clock master_clock  -min 1  -network_latency_included  [get_ports ScanEnable]
set_input_delay -clock master_clock  -max 12  -network_latency_included  [get_ports SDI]
set_input_delay -clock master_clock  -min 1  -network_latency_included  [get_ports SDI]
set_input_delay -clock master_clock  -max 12  -network_latency_included  [get_ports Test]
set_input_delay -clock master_clock  -min 1  -network_latency_included  [get_ports Test]
set_input_delay -clock master_clock  -max 12  -network_latency_included  [get_ports nCrank]
set_input_delay -clock master_clock  -min 1  -network_latency_included  [get_ports nCrank]
set_input_delay -clock master_clock  -max 12  -network_latency_included  [get_ports nTrip]
set_input_delay -clock master_clock  -min 1  -network_latency_included  [get_ports nTrip]
set_input_delay -clock master_clock  -max 12  -network_latency_included  [get_ports nFork]
set_input_delay -clock master_clock  -min 1  -network_latency_included  [get_ports nFork]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports {nDigit[3]}]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports {nDigit[3]}]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports {nDigit[2]}]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports {nDigit[2]}]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports {nDigit[1]}]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports {nDigit[1]}]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports {nDigit[0]}]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports {nDigit[0]}]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports SegF]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports SegF]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports DP]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports DP]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports SegC]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports SegC]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports SegE]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports SegE]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports SegD]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports SegD]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports SegA]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports SegA]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports SDO]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports SDO]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports SegB]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports SegB]
set_output_delay -clock master_clock  -max 8  -network_latency_included  [get_ports SegG]
set_output_delay -clock master_clock  -min 1  -network_latency_included  [get_ports SegG]
