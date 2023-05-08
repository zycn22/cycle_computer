
# system.tcl

database -open waves.shm -default

simvision {

  source /opt/cad/bim/fcde/tcl/routines.tcl
  source /opt/cad/bim/fcde/tcl/read_fig.tcl

  ecsWaves  {
    system.Clock
    system.nReset
    system.nMode
    system.nTrip
    system.nFork
    system.nCrank
    system.SegA
    system.SegB
    system.SegC
    system.SegD
    system.SegE
    system.SegF
    system.SegG
    system.DP
    system.nDigit
    system.mode_index
    } "Waves for Any Cycle Computer Design"
window new RegisterWindow  -name  "Registers for LED output"

    window  geometry  "Registers for LED output"  400x500+0+0

    register  using  "Registers for LED output"


    register add system.leddigit
    
    register addtype -type signalvalue -x0 50 -y0 30 -fontsize 24 -radix %s system.leddigit
 # Add signal values
 #SegA
    register addtype -type rectangle -x0 153 -y0 48 -x1 157 -y1 70 -fill white
    register addtype -type signalvalue -x0 150 -y0 50 -radix  %b\
      -fontsize 24 system.SegA
    register addtype -type rectangle -x0 183 -y0 48 -x1 187 -y1 70 -fill white
    register addtype -type signalvalue -x0 180 -y0 50 -radix  %b\
      -fontsize 24 system.SegA
    register addtype -type rectangle -x0 213 -y0 48 -x1 217 -y1 70 -fill white
    register addtype -type signalvalue -x0 210 -y0 50 -radix  %b\
      -fontsize 24 system.SegA

 #SegB
    register addtype -type rectangle -x0 243 -y0 78 -x1 247 -y1 100 -fill white
    register addtype -type signalvalue -x0 240 -y0 80 -radix  %b\
      -fontsize 24 system.SegB
    register addtype -type rectangle -x0 243 -y0 113 -x1 247 -y1 135 -fill white
    register addtype -type signalvalue -x0 240 -y0 115 -radix  %b\
      -fontsize 24 system.SegB
    register addtype -type rectangle -x0 243 -y0 143 -x1 247 -y1 165 -fill white
    register addtype -type signalvalue -x0 240 -y0 145 -radix  %b\
      -fontsize 24 system.SegB

  #SegC
    register addtype -type rectangle -x0 243 -y0 203 -x1 247 -y1 225 -fill white
    register addtype -type signalvalue -x0 240 -y0 205 -radix  %b\
      -fontsize 24 system.SegC
    register addtype -type rectangle -x0 243 -y0 233 -x1 247 -y1 255 -fill white
    register addtype -type signalvalue -x0 240 -y0 235 -radix  %b\
      -fontsize 24 system.SegC
    register addtype -type rectangle -x0 243 -y0 263 -x1 247 -y1 285 -fill white
    register addtype -type signalvalue -x0 240 -y0 265 -radix  %b\
      -fontsize 24 system.SegC

  #SegD
    register addtype -type rectangle -x0 153 -y0 293 -x1 157 -y1 315 -fill white
    register addtype -type signalvalue -x0 150 -y0 295 -radix  %b\
      -fontsize 24 system.SegD
     register addtype -type rectangle -x0 183 -y0 293 -x1 187 -y1 315 -fill white
    register addtype -type signalvalue -x0 180 -y0 295 -radix  %b\
      -fontsize 24 system.SegD
    register addtype -type rectangle -x0 213 -y0 293 -x1 217 -y1 315 -fill white
    register addtype -type signalvalue -x0 210 -y0 295 -radix  %b\
      -fontsize 24 system.SegD
  
  #SegE
    register addtype -type rectangle -x0 123 -y0 203 -x1 127 -y1 225 -fill white
    register addtype -type signalvalue -x0 120 -y0 205 -radix  %b\
      -fontsize 24 system.SegE
    register addtype -type rectangle -x0 123 -y0 233 -x1 127 -y1 255 -fill white
    register addtype -type signalvalue -x0 120 -y0 235 -radix  %b\
      -fontsize 24 system.SegE
    register addtype -type rectangle -x0 123 -y0 263 -x1 127 -y1 285 -fill white
    register addtype -type signalvalue -x0 120 -y0 265 -radix  %b\
      -fontsize 24 system.SegE

  #SegF
    register addtype -type rectangle -x0 123 -y0 78 -x1 127 -y1 100 -fill white
    register addtype -type signalvalue -x0 120 -y0 80 -radix  %b\
      -fontsize 24 system.SegF
    register addtype -type rectangle -x0 123 -y0 113 -x1 127 -y1 135 -fill white
    register addtype -type signalvalue -x0 120 -y0 115 -radix  %b\
      -fontsize 24 system.SegF
    register addtype -type rectangle -x0 123 -y0 143 -x1 127 -y1 165 -fill white
    register addtype -type signalvalue -x0 120 -y0 145 -radix  %b\
      -fontsize 24 system.SegF

  #SegG
    register addtype -type rectangle -x0 153 -y0 170.5 -x1 157 -y1 192.5 -fill white
    register addtype -type signalvalue -x0 150 -y0 172.5 -radix  %b\
      -fontsize 24 system.SegG
     register addtype -type rectangle -x0 183 -y0 170.5 -x1 187 -y1 192.5 -fill white
    register addtype -type signalvalue -x0 180 -y0 172.5 -radix  %b\
      -fontsize 24 system.SegG
    register addtype -type rectangle -x0 213 -y0 170.5 -x1 217 -y1 192.5 -fill white
    register addtype -type signalvalue -x0 210 -y0 172.5 -radix  %b\
      -fontsize 24 system.SegG
}

probe -create -shm system.leddigit

# =========================================================================
# Probe

  # Any signals included in register window but not in waveform window
  # should be probed

# =========================================================================
