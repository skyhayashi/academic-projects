#include "TM4C123GH6PM.h"
#include "trafficLED.h"

int main(void){
  trafficLED_Init(); // initialize LEDs
  PLL_Init(); // configure bus clock to 10 MHz
  SysTick_Init(); // initialize SysTick
  while(1){};
}
