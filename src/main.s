/**
 * @file: main.s
 * 
 * @brief: this file includes the procces for project using other .s .
 */
.section .text
.global main_asm   // To allow this function to be called from another file

// Declaration of the funtios gpio and uart how extern 
.extern project_adc_init_asm
.extern setFunction_pwm_asm 
.extern Cal_slices_asm
.extern Config_div_asm
.extern Config_TOP_asm
.extern Config_CC_asm
.extern Enable_PWM_asm 
.extern project_adc_read_asm


.equ    GPIO_PWM_1, 14
.equ    GPIO_ADC_1, 26
.equ    PWM_TOP_VALUE, 4095

// system main for project
main_asm: 
    // ADC Initialization
    bl project_adc_init_asm

    // PWM Initialization
    mov r0, #GPIO_PWM_1
    mov r1, #4
    bl setFunction_pwm_asm
    mov r0, #GPIO_PWM_1
    bl Cal_slices_asm
    mov r1, #128
    mov r2, #0
    bl Config_div_asm
    ldr r1, =PWM_TOP_VALUE
    bl Config_TOP_asm
    mov r1, #GPIO_PWM_1
    mov r2, #0
    bl Config_CC_asm
    mov r1, #1
    bl Enable_PWM_asm 

    loop:
        // leer un ADC
        bl  project_adc_read_asm
        mov r0, #GPIO_PWM_1
        bl Cal_slices_asm
        mov r1, #0
        mov r2, #0
        bl Config_CC_asm
    b loop 


.data
Delay: .dc.l 0x23A96


