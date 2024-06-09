/**
 * @file: PWM_asm.s
 * 
 * @brief: this file includes the ASM functions for the configuration pwm in asambler.
 */

/**
-------------------------------------------------------------------------------------------------------
PASOS PARA HACER EL PWM EN ASAMBLER 
-------------------------------------------------------------------------------------------------------
1. liberar el reset -------------------------------------------------------------------------------- f1
2. Configurar la funcion(que funcione con el pwm) -------------------------------------------------- f2
3. configurar el modulo PWM
    -CHx_div 0x04(freq
     divi) ----------------------------------------------------------------------- f3
    -CHx_TOP 0x10(WRAD) ---------------------------------------------------------------------------- f4 
    -CHx_CC 0x0c (counter compare) ----------------------------------------------------------------- f5
    -CHx_CSR 0x00(Enable) -------------------------------------------------------------------------- f6
    -Get_slice R_offset ---------------------------------------------------------------------------- f7
--------------------------------------------------------------------------------------------------------    
NOTA: PWM_base + Slice_offset + R_offset: Para saber donde esta ubicado cada registro en f3, f4, f5 y f6 
--------------------------------------------------------------------------------------------------------
4. Realizar las funciones del PWM.c
--------------------------------------------------------------------------------------------------------
Acceder a los slice por medio de los pines
    1. numero del pin en binario
    2. corrimiento a la derecha en un bit al numero
    3. and con "00111" para mantener los tres primeros bits(generalizar los slice despues del 15)
--------------------------------------------------------------------------------------------------------
PWM_BASE: 0x40050000
coger la base, al slice se multiplica por 20 y el 20 se lo sumamos a la base(registros de los slice)
--------------------------------------------------------------------------------------------------------
*/

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
.global gpio_init_pwm_asm                   // To allow this function to be called from another file
gpio_init_asm:
        push {r0, lr}
        bl releaseResetPWM
        pop {r0}
        bl setFunction_pwm_asm
        pop {pc}

/**
 * @brief releaseResetIOBank0
 *
 * This function releases the Reset for IO_Bank0
 * Parameters: None
 */
.equ    RESETS_BASE, 0x4000c000         // See RP2040 datasheet: 2.14.3 (Subsystem Resets)
.equ    RESET_DONE_OFFSET, 8
//.equ    PWM_BITMASK,  0x4000 // bit 14 en "1"
releaseResetPWM:
    ldr r0, =(RESETS_BASE+ATOMIC_CLR)	// Address for reset controller atomic clr register
	ldr r1, =(PWM_BITMASK)           // Load a '1' into bit 14: PWM
	str r1, [r0]    	                // Request to clear reset IOBank0
    ldr r0, =RESETS_BASE                // Base address for reset controller
rstPWMdone:     
	ldr r1, [r0, #RESET_DONE_OFFSET]    // Read reset done register
	ldr r2, =(PWM_BITMASK)          // Load a '1' into bit 14: PWM
	and r1, r1, r2		                // Check bit PWM (0: reset has not been released yet)
	beq rstPWMdone  
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
.equ    GPIO_PWM_FUNCTION, 4
.global setFunction_pwm_asm 
setFunction_pwm_asm:
	ldr r2, =(IO_BANK0_BASE+GPIO0_CTRL_OFFSET)  // Address for GPIO0_CTRL register
	mov r1, #GPIO_PWM_FUNCTION          // Select PWM for GPIO. See RP2040 datasheet: 2.19.2
    lsl r0, r0, #3                      // Prepare register offset for GPIOx (GPIO_NUM * 8)
	str r1, [r2, r0]	                // Store selected function (SIO) in GPIOx control register
    bx  lr
/*Funcion para calcular slices */
.global Cal_slices_asm
Cal_slices_asm:
    lsr r0, r0, #1
    mov r2, #7
    and r0, r0, r2
    bx lr

/*Configurar divisor de frecuencia */
.equ PWM_BASE, 0x40050000
.global Config_div_asm
Config_div_asm:
    push {r4}
    ldr r3, =PWM_BASE
    mov r4, #20
    mul r4, r4, r0
    add r4, r4, #4
    add r4, r4, r3

    lsl r1, #4
    orr r1, r1, r2
    str r1, [r4]   
    pop {r4}    
    bx lr

.global Config_CC_asm
Config_CC_asm:
    push {r4, r5}
    ldr r3, =PWM_BASE
    mov r4, #20
    mul r4, r4, r0
    mov r5, #12
    add r4, r4, r5
    add r4, r4, r3

    lsl r1, #4
    lsl r2, r1
    str r2, [r4]   
    pop {r4, r5}    
    bx lr

.global Config_TOP_asm 
Config_TOP_asm:
    push {r4}
    ldr r3, =PWM_BASE
    mov r2, #20
    mul r2, r2, r0
    mov r4, #16
    add r2, r2, r4
    add r2, r2, r3

    str r1, [r2]   
    pop {r4}    
    bx lr
    
.global Enable_PWM_asm 
Enable_PWM_asm:
    push {r4}
    ldr r3, =PWM_BASE
    mov r2, #20
    mul r2, r2, r0
    mov r4, #0
    add r2, r2, r4
    add r2, r2, r3

    str r1, [r2]   
    pop {r4}    
    bx lr

.data
PWM_BITMASK: .dc.l 0x4000