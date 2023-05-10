#define __MAIN_C__
//?
#include <stdint.h>
#include <stdbool.h>

// Define the raw base address values for the i/o devices

#define AHB_BUTTONS_BASE                          0x40000000
#define AHB_SENSORS_BASE                          0x50000000
#define AHB_LED_BASE                              0x60000000

// Define pointers with correct type for access to 32-bit i/o devices
//
// The locations in the devices can then be accessed as:
//    IPORT_REGS[0]
//    OPORT_REGS[0]
//
volatile uint32_t* BUTTONS_REGS = (volatile uint32_t*) AHB_BUTTONS_BASE;
volatile uint32_t* SENSORS_REGS = (volatile uint32_t*) AHB_SENSORS_BASE;
volatile uint32_t* LED_REGS = (volatile uint32_t*) AHB_LED_BASE;

#include <stdint.h>

//////////////////////////////////////////////////////////////////
// Functions provided to access i/o devices
//////////////////////////////////////////////////////////////////

void write_led(uint32_t value) {

  LED_REGS[0] = value;

}

uint32_t read_nFork(void) {
  
  return SENSORS_REGS[0];
} 

uint32_t read_nCrank(void) {
  
  return SENSORS_REGS[1];
} 

uint32_t read_fork_cnt(void) {
  
  return SENSORS_REGS[2];
} 

uint32_t read_pedal_cnt(void) {
  
  return SENSORS_REGS[3];
} 

//uint32_t read_timer(void) {
  
//  return SENSORS_REGS[4];
//}

//void reset_timer(void){
//  SENSORS_REGS[4] = 0x00000000;
//} 

//uint32_t read_status(void) {
  
//  return SENSORS_REGS[5];
//}

uint32_t read_nMode(void) {
  
  return BUTTONS_REGS[0];
}

uint32_t read_nTrip(void) {
  
  return BUTTONS_REGS[1];
}

uint32_t read_together_button(void) {
  
  return BUTTONS_REGS[2];
}

//////////////////////////////////////////////////////////////////
// Other Functions
//////////////////////////////////////////////////////////////////


uint32_t connect_digits(uint8_t DP, uint8_t digit3, uint8_t digit2, uint8_t digit1, uint8_t digit0) {
  uint32_t led_display = 0x00000000;

  uint32_t dp = DP << 15;
  uint32_t d3 = digit3 << 12;
  uint32_t d2 = digit2 << 8;
  uint32_t d1 = digit1 << 4;
  uint32_t d0 = digit0;
  
  led_display = dp + d3 + d2 + d1 + d0;
  
  return led_display;
}

//uint32_t low_pass_filter(uint32_t last_speed, uint32_t present_speed, uint8_t factor) {
  
  //return last_speed * (1 - factor) + present_speed * factor;
  
//}

//////////////////////////////////////////////////////////////////
// Main Function
//////////////////////////////////////////////////////////////////

int main(void) {

  uint8_t Mode = 0x00;
//  Odometer 
  uint32_t fork_counter = 0x00000000;
  uint32_t odometer = 0x00000000;

//  Trip Timer
  uint32_t time = 0x00000000;
  uint32_t accumulate_time = 0x00000000;
  uint32_t minute = 0x00000000;

//  Average Speed
  uint32_t av_ssni_419 = 0x00000000;

//  Maximum Speed
  uint32_t max_speed = 0x00000000;

//  Speedometer
  uint32_t speedometer = 0x00000000;
//  uint32_t last_speed = 0x00000000;
//  uint32_t present_speed = 0x00000000;
  uint32_t fork_time = 0x00000000;
  //uint8_t  lpf_factor=0.5;

//  Cadence
  uint32_t cadence_meter = 0x00000000;

//  Calorie
  uint32_t calorie = 0x00000000;

//  LED display
  uint8_t digits[4];
  digits[0] = 0;
  digits[1] = 0;
  digits[2] = 0;
  digits[3] = 0;
  uint8_t DP = 0x07;
  uint8_t digit_index = 0x02;
  uint16_t DiscreteDisplay = 0x0000;
  bool display = false;

//  Constant
  //uint32_t kinematic = 0.6142;

//  Use-defined Parameters
  uint32_t weight = 0x00000046;// default weight is 70kg 
  uint32_t wheel_size = 0x000000D6; // default wheel size is 214cm

//  Initialize
  write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));
// reset_timer();

//  Main program -- permernant loop  
  while(1){

    if (read_together_button()){
      digit_index = 0x02;
      digits[3] = 0x07;
      if (Mode != 0x06) {
        digits[2] = 0x02;
        digits[1] = 0x01;
        digits[0] = 0x04;
        Mode = 0x07;  // go to set wheel size
      }
      else {
        digits[2] = 0x00;
        digits[1] = 0x04;
        digits[0] = 0x00;
        Mode = 0x08;  // go to set weight
      }
    }

//    if(read_nMode() == 0){ 
//      if ( Mode > 0x06 ){
//        Mode = 0x00;  // back to odometer
//      }
//     else {
//       Mode = Mode + 1; // go to next Mode
//      }
//    }

    switch (Mode) {
      case 0x00: // odometer        range: 00.0 ~ 99.9 km
              if (!read_nTrip()){
                fork_counter = 0x00000000;
              }
              if (!read_nMode()){
                Mode = 0x01;
              } 

              DP = 0x02;
              digits[3] = 0x00;
              digits[2] = (odometer%1000)/100;
              digits[1] = (odometer%100)/10; 
              digits[0] = (odometer%100)%10;

              write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));

        break;
      case 0x01: // trip timer      time rage : 0.00 ~ 9.59 
              if(!read_nTrip()){ 
                accumulate_time = 0x00000000;
              }
              if(!read_nMode()){
                Mode = 0x02;
              }

              DP = 0x04;
              minute = time/60;
	      digits[3] = 0x01;
              digits[2] = (minute/60)%10;
              digits[1] = (minute%60)/10;
	      digits[0] = (minute%60)%10;

	      write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));

        break;
      case 0x02: // speedometer      range:  00.0 ~ 99.9 km/h
              if(!read_nMode()){
                Mode = 0x03;
              }
              
              DP = 0x02;
              digits[3] = 0x02;
              digits[2] = (speedometer%1000)/100;  
              digits[1] = (speedometer%100)/10; 
              digits[0] = (speedometer%100)%10;
              
              write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));

        break;
      case 0x03: // cadence meter
              if(!read_nMode()){
                Mode = 0x04;
                display = true;
              }

              DP = 0x01;
              digits[3] = 0x03;
              digits[2] = (cadence_meter%1000)/100; 
              digits[1] = (cadence_meter%100)/10; 
              digits[0] = (cadence_meter%100)%10; 

	      write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));
        break;
      case 0x04: // average speed
	      if(read_nTrip() == 0){
		fork_counter = 0x00000000;
                time = 0x00000000;
              }
              if(!read_nMode()){
                Mode = 0x05;
              }

              if (display){
                DP = 0x02;
                digits[3] = 0x04;
                digits[2] = (av_ssni_419%1000)/100;
                digits[1] = (av_ssni_419%100)/10; 
                digits[0] = (av_ssni_419%100)%10;
              }

	      write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));
        break;
      case 0x05: // max speed
              if(read_nTrip() == 0){
		max_speed = 0x00000000;
              }
              if(!read_nMode()){
                Mode = 0x06;
              }

              DP = 0x02;
	      digits[3] = 0x05;
              digits[2] = (max_speed%1000)/100;
              digits[1] = (max_speed%100)/10; 
              digits[0] = (max_speed%100)%10;
	
	      write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));
        break;
      case 0x06: // calorie cost
              if(read_nTrip() == 0){
                calorie = 0x00000000;
              }
              if(!read_nMode()){
                Mode = 0x00;
              }

              DP = 0x01;
	      digits[3] = 0x06;
              digits[2] = (calorie%1000)/100;
              digits[1] = (calorie%100)/10; 
              digits[0] = (calorie%100)%10;

	      write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));
        break;
      case 0x07: // set wheel size   (unit: cm)
	      if ( read_nMode() == 0 ) {
                if (digit_index!=0x00) {
                  digit_index--;
                }else {
                  Mode = 0x00;
                  wheel_size = digits[2]*100 + digits[1]*10 + digits[0];
                }
              }

              if ( read_nTrip() == 0 ) {
                digits[digit_index] += 1;
                if (digits[digit_index] > 0x09) {
                  digits[digit_index] = 0x00;
                }
              }  

              DP = 0x01;
	      write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));
        break;
      case 0x08: // set weight     (unit: kg)
              if ( read_nMode() == 0 ) {
                if (digit_index!=0x00){
                  digit_index--;
                }else {
                  Mode = 0x00;
                  weight = digits[2]*100 + digits[1]*10 + digits[0];
                }
              }

              if ( read_nTrip() == 0 ) {
                digits[digit_index] += 1;
                if (digits[digit_index] > 0x09) {
                  digits[digit_index] = 0x00;
                }
              }  

              DP = 0x01;
	      write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));
        break;
      default:  

            digits[0] = 0x08;
            digits[1] = 0x08;
            digits[2] = 0x08;
            digits[3] = 0x00;
            DP = 0x07;

            write_led(connect_digits(DP, digits[3], digits[2], digits[1], digits[0]));
        break;
    }


// accumulate the fork_counter and timer, calculate average speed
    if (read_nFork() == 0) {

      if(read_fork_cnt() != 0){
        fork_time = read_fork_cnt();
        //speedometer = wheel_size/(fork_time*30.52/1000)*360; 
        speedometer = (wheel_size*11796/fork_time);  // unit: 100m/h
        //av_ssni_419 = (av_ssni_419*(fork_counter)+speedometer)/(fork_counter+1);
        //av_ssni_419 = (0.36*((fork_counter) * wheel_size))/(time);
        fork_counter = fork_counter + 1;
      }
      else {
        speedometer = 0;
      }

      accumulate_time += fork_time;

      if (DiscreteDisplay < 0x8000) {
        DiscreteDisplay += fork_time;
        display = false;
      }
      else {
        DiscreteDisplay = 0;
        display = true; 
      }
    }
  
    if(read_fork_cnt() == 0){speedometer = 0;}

// calculate the distance
    odometer = fork_counter * wheel_size / 10000;

// calculate the timer
    //time = read_timer()/0x00008000;
    time = accumulate_time/0x00008000;

// compute the wheel speed
    if (speedometer > 0x000003E7){
      speedometer = 0x000003E7;
    }

  // compute the average wheel speed
     av_ssni_419 = ((fork_counter) * wheel_size*11796)/(accumulate_time);


// computer the pedal speed
    //cadence_meter = 60/(read_pedal_cnt()*30.52/1000000);
    cadence_meter = 1965924/read_pedal_cnt();
    if ((cadence_meter%5) != 0){
      cadence_meter = (cadence_meter/5+1)*5;
    }               

    if (cadence_meter >= 0x000003E3){
      cadence_meter = 0x000003E3;
    }

// save the maximum speed 
    if (speedometer >= max_speed){
      max_speed = speedometer;
    }

// compute the clorie 
    calorie = weight * fork_counter * wheel_size*3/500000;
  }
}

