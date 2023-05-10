# Cycle Computer
## OverView:
This is the ARM SoC Cycle Computer Group Project at University of Southampton in 2023.

Our bicycle computer System on Chip (SoC) is powered by the ARM Cortex-M0 core and is designed to provide riders with accurate 
and real-time information on their cycling performance. The SoC is equipped with two Hall sensors that detect the rotation of the wheel and the pedal, allowing for precise measurement of speed, distance, and other important metrics. The device also features two input buttons called “Mode” and “Trip” that allow for easy switching between display modes and adjustment of tire size and rider weight for more accurate calculations. With our SoC, riders can easily track their performance, including distance travelled, average and maximum speeds, riding time, and calories burned.

The product is based on the AMS 0.35μm CMOS technology and employs SoC (hardware/software co-design) design principles. The computer is clocked synchronously at 32.768kHz and features a multiplexed seven-segment LED display that shows measurement data. It receives signals from two hall effect sensors, one on the front wheel and the other on the pedal crank. The cycle computer supports different wheel sizes for calculating current speed and distance travelled, and the user should input their weight to calculate the calorie cost. The computer's buttons labelled “Mode” and “Trip” allow users to change the mode and set/reset data.

Our group members are: Yechengnuo Zhang, Yueran Wei, Jiashu Hu and Zhipeng Zhao.

## Modes & Functions of the computer

The cycle computer supports the following 7 functions:
- Distance travelled (Odometer).           Mode code: d 
- Duration of the ride (Trip Timer).       Mode code: t
- Current speed (Speedometer).             Mode code: v 
- Pedal cadence (Cadence meter).           Mode code: c 
- Average speed                            Mode code: a 
- Maximum speed                            Mode code: s 
- Calorie cost                             Mode code: j

## Architecture of the SoC
![Architecture](https://github.com/zycn22/cycle_computer/blob/main/cycle_copmuter_architecture_diagram.drawio.png)
