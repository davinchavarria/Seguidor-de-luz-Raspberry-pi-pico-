/*
 * Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

// Standard libraries
#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/adc.h"

// ADC header file

void adc_init_wrapper() {
    adc_init();
}

void adc_gpio_init_wrapper(ADC_GPIO_CH0){
    adc_gpio_init(ADC_GPIO_CH0);
}

void adc_select_input_wrapper(ADC_CH0){
    adc_select_input(ADC_CH0);
}

uint16_t  adc_read_wrapper(){
    return adc_read();
}
