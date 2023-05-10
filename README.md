# Cycle Computer
## OverView:
This is the ARM SoC Cycle Computer Group Project at University of Southampton in 2023.

Our bicycle computer System on Chip (SoC) is powered by the ARM Cortex-M0 core and is designed to provide riders with accurate 
and real-time information on their cycling performance. The SoC is equipped with two Hall sensors that detect the rotation of the wheel and the pedal, allowing for precise measurement of speed, distance, and other important metrics. The device also features two input buttons called “Mode” and “Trip” that allow for easy switching between display modes and adjustment of tire size and rider weight for more accurate calculations. With our SoC, riders can easily track their performance, including distance travelled, average and maximum speeds, riding time, and calories burned.

The product is based on the AMS 0.35μm CMOS technology and employs SoC (hardware/software co-design) design principles. The computer is clocked synchronously at 32.768kHz and features a multiplexed seven-segment LED display that shows measurement data. It receives signals from two hall effect sensors, one on the front wheel and the other on the pedal crank. The cycle computer supports different wheel sizes for calculating current speed and distance travelled, and the user should input their weight to calculate the calorie cost. The computer's buttons labelled “Mode” and “Trip” allow users to change the mode and set/reset data.

Our group members are: Yechengnuo Zhang, Yueran Wei, Jiashu Hu and Zhipeng Zhao.

## Modes & Functions of the computer

The cycle computer supports the following 7 functions:
<pre>
- Distance travelled (Odometer).           Mode code: d 
- Duration of the ride (Trip Timer).       Mode code: t
- Current speed (Speedometer).             Mode code: v 
- Pedal cadence (Cadence meter).           Mode code: c 
- Average speed                            Mode code: a 
- Maximum speed                            Mode code: s 
- Calorie cost                             Mode code: j
</pre>
## Architecture of the SoC
![Architecture](https://github.com/zycn22/cycle_computer/blob/main/cycle_copmuter_architecture_diagram.drawio.png)
### Buttons Interface
Buttons interface contains 3 registers which are Button[0] (nMode), Button[1] (nTrip) and together_button.
Button[0] and Button[1] store the data of nMode and nTrip buttons respectively. When nMode/nTrip is active, it will be 0, and when the ARM core reads the data in it, it will return to 1. together_button is generated inside the interface, which represents whether the two buttons are pressed together. When two buttons are pressed together, the Button[0] and Button[1] will not be active anymore, and the computer will be aware that the two buttons are pressed together.
In the process of determining whether two buttons are pressed at the same time, we set a time constant (30ms). Even if there is an difference in time between the two button presses, as long as the error time is within this time constant, they will be judged as simultaneous presses.

###  Hall-effect Sensors Interface
Sensors Interface contains 4 registers which are Sensor[0], Sensor[1], fork_cnt and crank_cnt.
Sensor[0] and Sensor[1] store the data of nFrok and nCrank respectively. When nFork/nCrank is active, it will be 0, and when the ARM core reads the data in it, it will return to 1.
fork_cnt and crank_cnt records the clock period elapsed for one revolution of the bicycle tire/pedal. The algorithm for fork_cnt is more complex than that of crank_cnt, after a certain period of time (2 seconds) if no signal is received from the next Hall sensor on the tire, the system will determine that the tire has stopped rotating.

### LED Display Interface
The LED Display Interface has only one write-only register seven_seg. The form of the bit partten in this register is:

<img src="https://github.com/zycn22/cycle_computer/blob/main/bit_pattern.png" width="600" height="40">

When the data is written into this register, it will output digits from 0 to 3 with decimal point in turn.

## Padring Arrangements & Bonding Diagram

Padring Arrangement             |  Bonding Diagram
:------------------------------:|:------------------------------:
<img src="https://github.com/zycn22/cycle_computer/blob/main/padring.png" width="400" height="400">  |  <img src="https://github.com/zycn22/cycle_computer/blob/main/BondingDiagram.png" width="300" height="300">
