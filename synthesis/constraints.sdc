# This is the constraints for synthesis

# Clock constraints
create_clock -period 3000 -name master_clock [get_ports Clock]

set_clock_latency      2.5 [get_clock master_clock]
set_clock_transition   0.5 [get_clock master_clock]
set_clock_uncertainty  1.0 [get_clock master_clock]

# Input and Output Timing
set_input_delay  12.0 -max -network_latency_included -clock master_clock \
    [remove_from_collection [all_inputs] [get_ports Clock]]
set_input_delay  1.0 -min -network_latency_included -clock master_clock \
    [remove_from_collection [all_inputs] [get_ports Clock]]

set_output_delay 8.0 -max -network_latency_included -clock master_clock \
    [all_outputs]
set_output_delay 1.0 -min -network_latency_included -clock master_clock \
    [all_outputs]

#Input Drive and Output Load
set_load 1.0  -max [all_outputs]
set_load 0.01 -min [all_outputs]

set_driving_cell -max -library c35_IOLIB_WC -lib_cell BU24P -pin PAD [all_inputs]
set_driving_cell -min -library c35_IOLIB_WC -lib_cell BU1P  -pin PAD [all_inputs]

#Timing Exclusions
set_false_path -from [get_ports nReset]

set_max_area 0
