#this is the cript for place and route  


##-----------------------------    IMPORT THE DESIGN    -------------------------------

  set io_filename ../padring/computer.io

  source edi_custom_c35b4.tcl

## initialize the database
  amsDbSetup

## specify the scan path
  specifyScanChain ScanChain0 -start SDI -stop SDO
  
## setup timing
  amsSetMMMC
  amsSetAnalysisView minmax {func test}

##------------------------------    PLACE PAD CELLS    ---------------------------------

  loadIoFile $io_filename

## view the dsign in GUI
  fit

##----------------------------    SPECIFY FLOOR PLAN    --------------------------------

## specifies a core ratio of 1:1, row density = 0.7, leave a space of 60um between core and pad for pad ring
  floorPlan -r 1 0.7 60 60 60 60

## add filler cells
  snap_ams_pads
  amsFillperi

##----------------------------    ADD CORE PAD RING    ---------------------------------

## specify the connectivity
  amsGlobalConnect both
  
  globalNetConnect gnd! -type pgpin -pin A -inst CORE_GND_* -module {}
  globalNetConnect vdd! -type pgpin -pin A -inst CORE_VDD_* -module {}

## add gnd! vdd! power ring
  addRing \
      -type core_rings \
      -nets {gnd! vdd!} \
      -center 1 \
      -layer {bottom MET3 top MET3 right MET4 left MET4} \
      -width 20 -spacing 2

##-----------------------------    ADD POWER ROUTING    --------------------------------

## add power routing
  sroute \
      -connect { blockPin padPin padRing corePin floatingStripe } \
      -layerChangeRange { MET1 MET4 } \
      -blockPinTarget { nearestTarget } \
      -padPinPortConnect { allPort oneGeom } \
      -padPinTarget { nearestTarget } \
      -corePinTarget { firstAfterRowEnd } \
      -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } \
      -allowJogging 1 \
      -crossoverViaLayerRange { MET1 MET4 } \
      -nets { vdd! gnd! } \
      -allowLayerChange 1 \
      -blockPin useLef \
      -targetViaLayerRange { MET1 MET4 }

  verifyGeometry
    if { [get_metric -value verify.geom.total] != 0 } {
      print "FLOORPLAN GEOMETRY CHECK FAILED - GIVING UP"
      return
    }

## save the design
  saveDesign floorplan.enc
  ## load the design with command: ----------> encounter -init floorplan.enc -win

##---------------------------------    PLACE CELLS    ----------------------------------

## change view 
  setDrawView place

## place standard cells in rows and cap cells at the end of each row
  placeDesign
  amsAddEndCaps

## add Tiehi/Tielo cells 
  setTieHiLoMode -cell {LOGIC1 LOGIC0} -maxFanout 10
  addTieHiLo

## save the design
  saveDesign placed.enc
  ## load the design with command: ----------> encounter -init placed.enc -win

##------------------------------    PRE-CTS OPTIMIZATION    -----------------------------

## Run the optimisation command in "Pre-CTS" mode 
  optDesign -preCTS

  timeDesign -preCTS
   if { [get_metric -value timing.setup.numViolatingPaths.all] != 0 } {
     print "PRECTS SETUP CHECK FAILED - GIVING UP"
     return
   }

##------------------------------    CLOCK TREE SYNTHESIS    -----------------------------

## specify the operation mode
  setCTSMode -engine ck
  setCTSMode -traceDPinAsLeaf true -traceIOPinAsLeaf true

## create a clock tree specification file in the CONSTRAINTS directory:
  createClockTreeSpec \
      -bufferList {CLKBU2 CLKBU4 CLKBU6 CLKBU8 CLKBU12 CLKBU15 \
                  CLKIN0 CLKIN1 CLKIN2 CLKIN3 CLKIN4 CLKIN6 \
                  CLKIN8 CLKIN10 CLKIN12 CLKIN15} \
      -routeClkNet -output CONSTRAINTS/clock.clk

## use the clock tree specification file to specify the clock tree and then run the synthesis
  specifyClockTree -file CONSTRAINTS/clock.clk
  ckSynthesis

## save the design
  saveDesign inc_clock_tree.enc
  ## load the design with command: ----------> encounter -init inc_clock_tree.enc -win

##-------------------------------    UPDATE CONSTRAINTS    -------------------------------

## we will be modifying both the functional mode and the test mode constraints
  set_interactive_constraint_modes {func test}

## Replace predicted latency and transition with actual values through clock tree
  set_propagated_clock [all_clocks]

## Previously the clock uncertainty was set to 1 ns to reflect a combination of the effect of the clock skew and the jitter in the input clock. Now we will reduce the uncertainty to 0.5 ns to reflect only the jitter in the input clock since the clock skew can be calculated from the differences in delay through the clock tree
  set_clock_uncertainty -setup 0.5 [get_clocks master_clock]
  set_clock_uncertainty -hold 0.1 [get_clocks master_clock]

##----------------------------    POST-CTS OPTIMIZATION    -------------------------------

  set_analysis_view -setup {func_max func_typ func_min} -hold {func_max func_typ func_min}

  optDesign -postCTS -hold
  
  timeDesign -postCTS -hold
   if { [get_metric -value timing.setup.numViolatingPaths.all] != 0 } {
     print "POSTCTS SETUP CHECK FAILED - GIVING UP"
     return
   }
   if { [get_metric -value timing.hold.numViolatingPaths.all] != 0 } {
     print "POSTCTS HOLD CHECK FAILED - GIVING UP"
     return
   }

##---------------------------------    ROUTE DESIGN    -----------------------------------

## signal routing 
  routeDesign -globalDetail

##---------------------------     POST-ROUTE OPTIMIZATION    -----------------------------

  setDelayCalMode -engine default -siAware true
  setAnalysisMode -analysisType onChipVariation

  optDesign -postRoute -hold
  optDesign -postRoute
  optDesign -postRoute -drv

  timeDesign -postRoute -hold
   if { [get_metric -value timing.setup.numViolatingPaths.all] != 0 } {
     print "POSTROUTE SETUP CHECK FAILED - GIVING UP"
     return
   }
   if { [get_metric -value timing.hold.numViolatingPaths.all] != 0 } {
     print "POSTROUTE HOLD CHECK FAILED - GIVING UP"
     return
   }

##---------------------------    ADD CORE FILLER CELLS    --------------------------------

  amsFillcore

##----------------------------    VERIFY THE DESIGN    -----------------------------------

  verifyConnectivity
   if { [get_metric -value verify.conn] != 0 } {
       print "CONNECTIVITY CHECK FAILED - GIVING UP"
       return
   }

  verifyGeometry
   if { [get_metric -value verify.geom.total] != 0 } {
       print "GEOMETRY CHECK FAILED - GIVING UP"
       return
   }

##------------------------------    CHECK THE SIZE    ------------------------------------

  set size [ dbGet top.fPlan.boxes ]
  print "CHIP SIZE IS $size"

##------------------------------    SAVE THE DESIGN    -----------------------------------

  saveDesign routed.enc
  amsWrite final
  amsWriteSDF4View {func_max}
  ## load the design with command: ----------> encounter -init routed.enc -win

  saveOaDesign computer_post_process computer layout

  print "PLACE AND ROUTE COMPLETED"








































