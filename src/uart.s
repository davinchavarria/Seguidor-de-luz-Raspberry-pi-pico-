/**
 * @file: uart.s
 * 
 * @brief: this file includes the ASM functions for the blinking program.
 */

/**
 * @brief uart_text_Foto_Resistors.
 *
 * This function uses printf to send a message to the serial terminal
 * The function printf requires to be called through its wrapper __wrap_printf
 * The printf parameters are passed through registers r0-r3 and the stack. They
 * correspond to arguments in the string (%s, %d, %c, etc.). r0 is the reference to
 * the message pointer.
 * Parameters:
 *  R0: ADC0_status
 *  R1: ADC1_status
 */
.global uart_text_Foto_Resistors

uart_text_Foto_Resistors_status_1:        .string "*** Value read from ADC channel 0: %u\n"
uart_text_Foto_Resistors_status_2:        .string "*** Value read from ADC channel 1: %u\n"

.align 2
uart_text_Foto_Resistors:
    push    {r4, r5, lr}
    //guardar valores de los fotoresistores
    mov r4, r0     
    mov r5, r1
    // Prepare argument no. 1 with full text
    ldr r0, =uart_text_Foto_Resistors_status_1       
    mov r1, r4
    // Call printf wrapper function
    bl      __wrap_printf 
    // Prepare argument no. 2 with full text
    ldr r0, =uart_text_Foto_Resistors_status_2      
    mov r1, r5
    // Call printf wrapper function
    bl      __wrap_printf                    
    pop {r4, r5, pc} // Return from subroutine