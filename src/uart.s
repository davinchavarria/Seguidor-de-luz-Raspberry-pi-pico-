/**
 * @file: uart.s
 * 
 * @brief: this file includes the ASM functions for the blinking program.
 */

/**
 * @brief uart_printMsgLED_asm.
 *
 * This function uses printf to send a message to the serial terminal
 * The function printf requires to be called through its wrapper __wrap_printf
 * The printf parameters are passed through registers r0-r3 and the stack. They
 * correspond to arguments in the string (%s, %d, %c, etc.). r0 is the reference to
 * the message pointer.
 * Parameters:
 *  R0: LED1_status
 *  R1: LED2_status
 */
.global uart_printMsgLED_asm
uart_text_LEDstatus:        .string "LED 1 is %s, LED 2 is %s\n"
uart_text_LEDstatus_on:     .string "ON"
uart_text_LEDstatus_off:    .string "OFF"
.align 2
uart_printMsgLED_asm:
    push    {lr}
uart_printMsg_chkLED2:
    cmp     r1, #0                          // Check if LED2 is on
    beq     uart_printMsg_LED2off           // If eq then LED2 is off
    ldr     r2, =uart_text_LEDstatus_on     // Prepare argument no. 3 with ON text
    b       uart_printMsg_chkLED1           // Go to check LED1 status
uart_printMsg_LED2off:
    ldr     r2, =uart_text_LEDstatus_off    // Prepare argument no. 3 with OFF text
uart_printMsg_chkLED1:
    cmp     r0, #0                          // Check if LED1 is on
    beq     uart_printMsg_LED1off           // If eq then LED1 is off
    ldr     r1, =uart_text_LEDstatus_on     // Prepare argument no. 2 with ON text
    b       _uart_printMsgLED_asm           // Go to prepare argument no. 1
uart_printMsg_LED1off:
    ldr     r1, =uart_text_LEDstatus_off    // Prepare argument no. 2 with OFF text
_uart_printMsgLED_asm:
    ldr     r0, =uart_text_LEDstatus        // Prepare argument no. 1 with full text
    bl      __wrap_printf                   // Call printf wrapper function
    pop {pc}                                // Return from subroutine