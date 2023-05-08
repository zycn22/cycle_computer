#######################################################
#                                                     
#  Encounter Command Logging File                     
#  Created on Sun Apr 30 22:20:36 2023                
#                                                     
#######################################################

#@(#)CDS: Encounter v14.26-s039_1 (64bit) 07/15/2015 11:34 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute v14.26-s022 NR150713-1956/14_26-UB (database version 2.30, 267.6.1) {superthreading v1.25}
#@(#)CDS: CeltIC v14.26-s013_1 (64bit) 07/14/2015 03:32:40 (Linux 2.6.18-194.el5)
#@(#)CDS: AAE 14.26-s007 (64bit) 07/15/2015 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 14.26-s010_1 (64bit) Jul 15 2015 01:38:12 (Linux 2.6.18-194.el5)
#@(#)CDS: CPE v14.26-s026
#@(#)CDS: IQRC/TQRC 14.2.2-s217 (64bit) Wed Apr 15 23:10:24 PDT 2015 (Linux 2.6.18-194.el5)

setCheckMode -tapeOut true
set defHierChar /
set init_oa_ref_lib {TECH_C35B4  CORELIB  IOLIB_4M  }
set init_verilog VERILOG/computer.v
set init_top_cell computer
set init_pwr_net {vdd!  vdd3r1! vdd3r2! vdd3o!  }
set init_gnd_net {gnd!  gnd3r! gnd3o!  }
set init_mmmc_file c35_computer_mmmc.view
set conf_gen_footprint 1
set fp_core_to_left 50.000000
set fp_core_to_right 50.000000
set fp_core_to_top 50.000000
set fp_core_to_bottom 50.000000
set lsgOCPGainMult 1.000000
set conf_ioOri R0
set fp_core_util 0.850
set init_assign_buffer 0
set conf_in_tran_delay 0.1ps
set init_import_mode { -keepEmptyModule 1 -treatUndefinedCellAsBbox 0}
set init_layout_view layout
set init_abstract_view abstract
print {---# TCL Script amsSetup.tcl loaded}
print {---# Additional ams TCL Procedures loaded}
getVersion
getVersion
print {### austriamicrosystems HitKit-Utilities Menu added}
set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
init_design
setCTSMode -bottomPreferredLayer 1
setMaxRouteLayer 4
setExtractRCMode -lefTechFileMap /opt/cad/designkits/ams/v410/cds/HK_C35/LEF/c35b4/qrclaymap.ccl
checkDesign -all -outDir checkDesignDbSetup
check_timing -verbose  > $filename2
print {#### }
print {---# CheckDesign Result: checkDesignDbSetup/computer.main.htm}
print {---# CheckTiming Result: checkDesignDbSetup/computer.checkTiming}
print {#### }
specifyScanChain ScanChain0 -start SDI -stop SDO
print {---# Setup MMMC
---#}
create_rc_corner -name ams_rc_corner_typ  -cap_table {/opt/cad/designkits/ams/v410/cds/HK_C35/LEF/encounter/c35b4-typical.capTable}  -preRoute_res {1.0}  -postRoute_res {1.0}  -preRoute_cap {1.0}  -postRoute_cap {1.0}  -postRoute_xcap {1.0}  -qx_tech_file {/opt/cad/designkits/ams/v410/assura/c35b4/c35b4thinall/RCX-typical/qrcTechFile}
print {---#   rc_corner        : ams_rc_corner_typ}
create_rc_corner -name ams_rc_corner_wc  -cap_table {/opt/cad/designkits/ams/v410/cds/HK_C35/LEF/encounter/c35b4-worst.capTable}  -preRoute_res {1.0} -postRoute_res {1.0} -preRoute_cap {1.0} -postRoute_cap {1.0} -postRoute_xcap {1.0}  -qx_tech_file {/opt/cad/designkits/ams/v410/assura/c35b4/c35b4thinall/RCX-worst/qrcTechFile}
print {---#   rc_corner        : ams_rc_corner_wc}
create_rc_corner -name ams_rc_corner_bc  -cap_table {/opt/cad/designkits/ams/v410/cds/HK_C35/LEF/encounter/c35b4-best.capTable}  -preRoute_res {1.0} -postRoute_res {1.0} -preRoute_cap {1.0} -postRoute_cap {1.0} -postRoute_xcap {1.0}  -qx_tech_file {/opt/cad/designkits/ams/v410/assura/c35b4/c35b4thinall/RCX-best/qrcTechFile}
print {---#   rc_corner        : ams_rc_corner_bc}
create_library_set -name libs_min -timing {  /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_CORELIB_BC.lib  /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_IOLIB_BC.lib  }
create_library_set -name libs_max -timing {  /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_CORELIB_WC.lib  /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_IOLIB_WC.lib  }
create_library_set -name libs_typ -timing {  /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_CORELIB_TYP.lib  /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_IOLIB_TYP.lib  }
print {---#   lib-sets         : libs_min, libs_max, libs_typ}
create_constraint_mode -name $cons -sdc_files $filename
create_constraint_mode -name $cons -sdc_files $filename
print {---#   constraint-modes : func test}
create_delay_corner -name corner_min -library_set {libs_min} -opcond_library {c35_CORELIB_BC} -opcond {BEST-MIL} -rc_corner {ams_rc_corner_bc}
create_delay_corner -name corner_max -library_set {libs_max} -opcond_library {c35_CORELIB_WC} -opcond {WORST-MIL} -rc_corner {ams_rc_corner_wc}
create_delay_corner -name corner_typ -library_set {libs_typ} -opcond_library {c35_CORELIB_TYP} -opcond {TYPICAL} -rc_corner {ams_rc_corner_typ}
print {---#   delay-corners    : corner_min, corner_max, corner_typ}
print {---#   analysis-views   : }
print {---#
---# use following command to show analysis view definitions
         report_analysis_view 
}
