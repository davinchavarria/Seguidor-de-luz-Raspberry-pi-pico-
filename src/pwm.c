/**
 * @file pwm.c
 */

// Standard libraries
#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/pwm.h"

// PWM header file
#include "pwm.h"

// PWM initialization for the project
void project_pwm_init(int PWM_GPIO_CHA) {
    // Initialize function PWM for GPIO: PWM_GPIO_CHA
    setFunction_pwm_asm(PWM_GPIO_CHA, GPIO_FUNC_PWM);
    // Determine the PWM slice connected to GPIO: PWM_GPIO_CHA
    uint sliceNum = Cal_slices_asm(PWM_GPIO_CHA);
    // Set period for frequency divisor
    Config_div_asm(sliceNum, PWM_DIV_INTEGER, PWM_DIV_FRAC); // What frequency enters to the PWM?
    // Set top (wrap) value (Determines the frequency)
    Config_TOP_asm(sliceNum, PWM_TOP_VALUE);
    // Set zero duty
    Config_CC_asm(sliceNum, PWM_CHA, PWM_DUTY_ZERO);
    // Enable PWM
    Enable_PWM_asm(sliceNum, true);    
}

// PWM counter compare level changer
void project_pwm_set_chan_level(uint value, int PWM_GPIO_CHA) {
    // Determine the PWM slice connected to GPIO: PWM_GPIO_CHA
    uint sliceNum = Cal_slices_asm(PWM_GPIO_CHA);
    // Set duty
    Config_CC_asm(sliceNum, PWM_CHA, value);
}