/**
 * @file main.c
 * @brief This example takes a sample using the ADC channel 0 (GPIO26) and writes it
 * to the PWM slice 0 channel A (GPIO16).
 * 
 * To carry out the example, the user must connect a potentiometer to GND, GPIO26 and VCC33 pins,
 * and a LED in series with a 470-ohm resistor between GPIO16 and GND.
 */
//cuando se deje de proporcionar luminidad a los fotoresistores ir parando el carro poco a poco ------------------------------------ importante(plus)
//Aumentar un diezporciento la velocidad en la que se mueve el carrito ------------------------------------------------------------- importante(plus)

// Standard libraries
#include <stdio.h>
#include "pico/stdlib.h"

// The header files
#include "main.h"
#include "adc.h"
#include "pwm.h"

/**
 * @brief Main program.
 *
 * This function initializes the MCU and does an infinite cycle.
 */
int main() {
	// STDIO initialization
    stdio_init_all();
	
	// ADC Initialization
    project_adc_init_asm();

    // PWM Initialization
    project_pwm_init(18);
    project_pwm_init(14);
    
	// Infinite loop to take samples and send them to PWM channel
    while (1) {
        uint16_t adcSample,adcSample2 ;
        // Read ADC sample (12-bit: 0 to 4095)
        adcSample = project_adc_read_asm(0); //lextrura del gpio26(ADC0)
        adcSample2 = project_adc_read_asm(1);//lextrura del gpio27(ADC1)
        //adcSample2 = ((float)adcSample / 4095) * 100;
        printf("*** Value read from ADC channel 0: %d ***\n", adcSample);
        printf("*** Value read from ADC channel 0: %d ***\n", adcSample2);
        // Send value to PWM channel A (level: 0 to 4095)
        // But, first guarantee 0% duty for values near zero
        if (adcSample < ADC_MIN_READVALUE)
           adcSample = 0;  
        if (adcSample2 < ADC_MIN_READVALUE)
           adcSample2 = 0; 
        project_pwm_set_chan_level((uint)adcSample, 14);
        project_pwm_set_chan_level((uint)adcSample2, 18);
        // Wait for DELAY milliseconds
        sleep_ms(DELAY);
    }
	
    return 0;
}