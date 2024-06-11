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

	//llamar a ASM MAIN
    main_asm();
	
    return 0;
}