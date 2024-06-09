/**
 * @file: gpio.s
 * 
 * @brief: this file includes the ASM functions for the blinking program.
 */

@ Cambiar los parametros de enytrada para que funcionen para ADC(0x0001), PWM(0x4000), GPIO(0x0020)

// General definitions
.equ    ATOMIC_XOR, 0x1000
.equ    ATOMIC_SET, 0x2000
.equ    ATOMIC_CLR, 0x3000

/**
 * @brief gpio_init_asm.
 *
 * This function initializes the GPIO module
 * Parameters:
 *  R0: GPIO_NUM
 */
.global gpio_init_asm                   // To allow this function to be called from another file
gpio_init_asm:
        push {r0, lr}
        bl releaseResetIOBank0
        pop {r0}
        bl setFunctionGPIO
        pop {pc}

/**
 * @brief releaseResetIOBank0
 *
 * This function releases the Reset for IO_Bank0
 * Parameters: None
 */
.equ    RESETS_BASE, 0x4000c000         // See RP2040 datasheet: 2.14.3 (Subsystem Resets)
.equ    RESET_DONE_OFFSET, 8
.equ    IO_BANK0_BITMASK,  32
releaseResetIOBank0:
    ldr r0, =(RESETS_BASE+ATOMIC_CLR)	// Address for reset controller atomic clr register
	mov r1, #IO_BANK0_BITMASK           // Load a '1' into bit 5: IO_Bank0
	str r1, [r0]    	                // Request to clear reset IOBank0
    ldr r0, =RESETS_BASE                // Base address for reset controller
rstiobank0done:     
	ldr r1, [r0, #RESET_DONE_OFFSET]    // Read reset done register
	mov r2, #IO_BANK0_BITMASK           // Load a '1' into bit 5: IO_Bank0
	and r1, r1, r2		                // Check bit IO_Bank0 (0: reset has not been released yet)
	beq rstiobank0done
    bx  lr

/**
 * @brief setFunctionGPIO.
 *
 * This function selects function SIO for GPIOx
 * Parameters:
 *  R0: GPIO_NUM
 */
.equ    IO_BANK0_BASE, 0x40014000       // See RP2040 datasheet: 2.19.6 (GPIO)
.equ    GPIO0_CTRL_OFFSET, 4
.equ    GPIO_SIO_FUNCTION, 5
setFunctionGPIO:
	ldr r2, =(IO_BANK0_BASE+GPIO0_CTRL_OFFSET)  // Address for GPIO0_CTRL register
	mov r1, #GPIO_SIO_FUNCTION          // Select SIO for GPIO. See RP2040 datasheet: 2.19.2
    lsl r0, r0, #3                      // Prepare register offset for GPIOx (GPIO_NUM * 8)
	str r1, [r2, r0]	                // Store selected function (SIO) in GPIOx control register
    bx  lr

/**
 * @brief gpio_set_dir_asm.
 *
 * This function sets the direction for a single GPIOx
 * Parameters:
 *  R0: GPIO_NUM
 *  R1: OUT (0: Input, 1: Output)
 */
.global gpio_set_dir_asm                // To allow this function to be called from another file
.equ    SIO_BASE, 0xd0000000            // See RP2040 datasheet: 2.3.1.7 (Processor Subsystem, SIO)
.equ    GPIO_OE_OFFSET,        32
.equ    GPIO_OE_SET_OFFSET,    4
.equ    GPIO_OE_CLR_OFFSET,    8
gpio_set_dir_asm:
	mov r2, #1			                // load a '1' to be shifted GPIO_NUM places
	lsl r2, r2, r0 	                    // shift the bit over to align with GPIO_NUM
	ldr r0, =(SIO_BASE+GPIO_OE_OFFSET)  // Address for GPIO_OE register
    cmp r1, #0                          // Check parameter to set input or output on GPIO GPIO_NUM
    beq gpio_set_dir_asm_clr            // If zero then GPIO GPIO_NUM must be an input
	str r2, [r0, #GPIO_OE_SET_OFFSET]   // set GPIO_NUM GPIO as an output
    bx  lr
gpio_set_dir_asm_clr:
	str r2, [r0, #GPIO_OE_CLR_OFFSET]   // set GPIO_NUM GPIO as an input
    bx  lr

/**
 * @brief gpio_put_asm.
 *
 * This function initializes the GPIO module
 * Parameters:
 *  R0: GPIO_NUM
 *  R1: VALUE (if false clear the GPIOx, otherwise set it)
 */
.global gpio_put_asm                    // To allow this function to be called from another file
.equ    GPIO_OUT_OFFSET,      16
.equ    GPIO_OUT_SET_OFFSET,   4
.equ    GPIO_OUT_CLR_OFFSET,   8
gpio_put_asm:
	mov r2, #1			                // load a '1' to be shifted GPIO_NUM places
	lsl r2, r2, r0 	                    // shift the bit over to align with GPIO_NUM
	ldr r0, =(SIO_BASE+GPIO_OUT_OFFSET) // Address for GPIO_OE register
    cmp r1, #0                          // Check parameter to set input or output on GPIO GPIO_NUM
    beq gpio_put_asm_clr                // If zero then GPIO GPIO_NUM must be an input
	str r2, [r0, #GPIO_OUT_SET_OFFSET]  // set GPIO_NUM GPIO as '1'
    bx  lr
gpio_put_asm_clr:
	str r2, [r0, #GPIO_OUT_CLR_OFFSET]  // set GPIO_NUM GPIO as '0'
    bx  lr


/**
 * @brief delay_asm.
 *
 * This function spends several cycles doing nothing
 * Parameters:
 *  R0: BIG_NUM
 */
.global delay_asm                       // To allow this function to be called from another file
delay_asm:
    sub r0, r0, #1
    bne delay_asm        
    bx  lr
