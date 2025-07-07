#include "trafficLED.h"

int count = 0;

void trafficLED_Init(void){
  SYSCTL->RCGCGPIO |= 0x02; // activate clock for Port B
  while((SYSCTL->PRGPIO&0x02)==0){}; // ready?
  GPIOB->DIR |= 0x3F; // make PB5-0 outputs
  GPIOB->DEN |= 0x3F; // enable digital I/O on PB5-0
}

void PLL_Init(void){
  SYSCTL->RCC2 |= 0x80000000; // use RCC2
  SYSCTL->RCC2 |= 0x00000800; // bypass PLL while initializing
  SYSCTL->RCC = (SYSCTL->RCC&~0x000007C0)+0x00000540; // 16 MHz
  SYSCTL->RCC2 &= ~0x00000070; // configure for main oscillator source
  SYSCTL->RCC2 &= ~0x00002000; // activate PLL by clearing PWRDN
  SYSCTL->RCC2 |= 0x40000000; // use 400 MHz PLL
  SYSCTL->RCC2 = (SYSCTL->RCC2&~0x1FC00000)+(39<<22); // 10 MHz
  while((SYSCTL->RIS&0x00000040)==0){}; // wait for the PLL to lock
  SYSCTL->RCC2 &= ~0x00000800; // enable PLL by clearing BYPASS
}

void SysTick_Init(void){
  SysTick->CTRL = 0; // disable SysTick during setup
  SysTick->LOAD = 9999999; // reload value
  SysTick->VAL = 0; // any write to CURRENT clears it
  SysTick->CTRL = 0x00000007; // enable SysTick with core clock and interrupts (local)
  __enable_irq(); enable interrupts (global)
}

void SysTick_Handler(void){ // SysTick interrupt handler; toggle LEDs in this function
  if(count==0){ // state 0 -> NS: Green & EW: Red
    GPIOB->DATA &= 0xC0;
    GPIOB->DATA |= 0x0C;
  }
  if(count==10){ // state 1 -> NS: Yellow & EW: Red
    GPIOB->DATA &= 0xC0;
    GPIOB->DATA |= 0x0A;
  }
  if(count==12){ // state 2 -> NS: Red & EW: Red
    GPIOB->DATA &= 0xC0;
    GPIOB->DATA |= 0x09;
  }
  if(count==13){ // state 3 -> NS: Red & EW: Green
    GPIOB->DATA &= 0xC0;
    GPIOB->DATA |= 0x21;
  }
  if(count==23){ // state 4 -> NS: Red & EW: Yellow
    GPIOB->DATA &= 0xC0;
    GPIOB->DATA |= 0x11;
  }
  if(count==25){ // state 5 -> NS: Red & EW: Red
    GPIOB->DATA &= 0xC0;
    GPIOB->DATA |= 0x09;
  }
  count++;
  if(count==26){
    count = 0;
  }
}
