/**
 * @file pwm.h
 * @brief Header file for the pwm.c file
 */

#include <stdint.h>

// Avoid duplication in code
#ifndef _PWM_H_
#define _PWM_H_

// Definitions and prototypes
//#define PWM_GPIO_CHA        18
#define PWM_CHA             0
#define PWM_DIV_INTEGER     128
#define PWM_DIV_FRAC        0
#define PWM_TOP_VALUE       4095
#define PWM_DUTY_ZERO       0 

void setFunction_pwm_asm(uint, uint);
uint16_t Cal_slices_asm(uint); 
void Config_div_asm(uint16_t, uint, uint); 
void Config_TOP_asm(uint16_t, uint); 
void Config_CC_asm(uint16_t, uint, uint);
void Enable_PWM_asm(uint16_t,  bool);  


void project_pwm_init(int);
void project_pwm_set_chan_level(uint, int);

#endif