create_library_set -name libs_typ\
   -timing\
    [list /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_CORELIB_TYP.lib\
    /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_IOLIB_TYP.lib]
create_library_set -name libs_min\
   -timing\
    [list /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_CORELIB_BC.lib\
    /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_IOLIB_BC.lib]
create_library_set -name libs_max\
   -timing\
    [list /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_CORELIB_WC.lib\
    /opt/cad/designkits/ams/v410/liberty/c35_3.3V/c35_IOLIB_WC.lib]
create_rc_corner -name ams_rc_corner_wc\
   -cap_table /opt/cad/designkits/ams/v410/cds/HK_C35/LEF/encounter/c35b4-worst.capTable\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -qx_tech_file /opt/cad/designkits/ams/v410/assura/c35b4/c35b4thinall/RCX-worst/qrcTechFile
create_rc_corner -name ams_rc_corner_typ\
   -cap_table /opt/cad/designkits/ams/v410/cds/HK_C35/LEF/encounter/c35b4-typical.capTable\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -qx_tech_file /opt/cad/designkits/ams/v410/assura/c35b4/c35b4thinall/RCX-typical/qrcTechFile
create_rc_corner -name ams_rc_corner_bc\
   -cap_table /opt/cad/designkits/ams/v410/cds/HK_C35/LEF/encounter/c35b4-best.capTable\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -qx_tech_file /opt/cad/designkits/ams/v410/assura/c35b4/c35b4thinall/RCX-best/qrcTechFile
create_delay_corner -name corner_typ\
   -library_set libs_typ\
   -opcond_library c35_CORELIB_TYP\
   -opcond TYPICAL\
   -rc_corner ams_rc_corner_typ
create_delay_corner -name corner_min\
   -library_set libs_min\
   -opcond_library c35_CORELIB_BC\
   -opcond BEST-MIL\
   -rc_corner ams_rc_corner_bc
create_delay_corner -name corner_max\
   -library_set libs_max\
   -opcond_library c35_CORELIB_WC\
   -opcond WORST-MIL\
   -rc_corner ams_rc_corner_wc
create_constraint_mode -name test\
   -sdc_files\
    [list ${cvd}/mmmc/modes/test/test.sdc]
create_constraint_mode -name func\
   -sdc_files\
    [list ${cvd}/mmmc/modes/func/func.sdc]
create_analysis_view -name test_max -constraint_mode test -delay_corner corner_max
create_analysis_view -name func_max -constraint_mode func -delay_corner corner_max
create_analysis_view -name test_typ -constraint_mode test -delay_corner corner_typ
create_analysis_view -name func_typ -constraint_mode func -delay_corner corner_typ
create_analysis_view -name test_min -constraint_mode test -delay_corner corner_min
create_analysis_view -name func_min -constraint_mode func -delay_corner corner_min
set_analysis_view -setup [list func_max func_typ func_min] -hold [list func_max func_typ func_min]
