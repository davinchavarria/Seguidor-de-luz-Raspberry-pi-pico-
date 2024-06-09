/**
 * @file main.h
 * @brief Header file for the example
 */
 
// Avoid duplication in code
#ifndef _MAIN_H_
#define _MAIN_H_

void main_asm(); 
void project_adc_init_asm();
void project_pwm_init_asm(int);
uint16_t project_adc_read_asm(int);
void project_pwm_set_chan_level_asm(uint, int); 

// Definitions and prototypes
#define DELAY               200

#endif