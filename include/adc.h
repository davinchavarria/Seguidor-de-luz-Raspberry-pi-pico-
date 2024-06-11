/**
 * @file adc.h
 * @brief Header file for the adc.c file
 */

#include <stdint.h>

// Avoid duplication in code
#ifndef _ADC_H_
#define _ADC_H_

// Definitions and prototypes

#define ADC_MIN_READVALUE   900

void adc_init_wrapper(); 
void adc_gpio_init_wrapper(int);
void adc_select_input_wrapper(int);
uint16_t adc_read_wrapper(); 
/// @brief 
void project_adc_init_asm(); 
uint16_t project_adc_read_asm(int); 


#endif 