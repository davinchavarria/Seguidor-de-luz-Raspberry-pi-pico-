/**
 * @file: main.s
 * 
 * @brief: this file includes the procces for project using other .s .
 */
.section .text
  // To allow this function to be called from another file

// Declaration of the funtios gpio and uart how extern 
.extern project_adc_init_asm
.extern setFunction_pwm_asm 
.extern Cal_slices_asm
.extern Config_div_asm
.extern Config_TOP_asm
.extern Config_CC_asm
.extern Enable_PWM_asm 
.extern project_adc_read_asm
.extern uart_text_Foto_Resistors
.extern delay_asm 


.equ    GPIO_PWM_1, 14
.equ    GPIO_ADC_1, 26
.equ    GPIO_PWM_2, 18
.equ    GPIO_ADC_2, 27
.equ    PWM_TOP_VALUE, 4095
.equ    MIN_VALUE_READ, 910
.equ    Delay, 0x4C4B40


.global main_asm 
// system main for project
main_asm: 
    push {r4, r5, lr}
    // ADC Initialization
    bl project_adc_init_asm

    // PWM Initialization one
        // Initialize function PWM for GPIO: PWM_GPIO_CHA
        mov r0, #GPIO_PWM_1
        mov r1, #4
        push {r0}
        bl setFunction_pwm_asm
        pop {r0}

        // Determine the PWM slice connected to GPIO: PWM_GPIO_CHA
        bl Cal_slices_asm

        // Set period for frequency divisor
        mov r1, #128 //PWM_DIV_INTEGER
        mov r2, #0
        push {r0}
        bl Config_div_asm
        pop {r0}

        // Set top (wrap) value (Determines the frequency)
        ldr r1, =PWM_TOP_VALUE
        push {r0}
        bl Config_TOP_asm
        pop {r0}

        // Set zero duty
        mov r1, #0
        mov r2, #0
        push {r0}
        bl Config_CC_asm
        pop {r0}

        // Enable PWM
        mov r1, #1
        bl  Enable_PWM_asm

    // PWM Initialization two
        mov r0, #GPIO_PWM_2
        mov r1, #4

        // Initialize function PWM for GPIO: PWM_GPIO_CHA
        push {r0}
        bl setFunction_pwm_asm
        pop {r0}

        // Determine the PWM slice connected to GPIO: PWM_GPIO_CHA
        bl Cal_slices_asm

        // Set period for frequency divisor
        mov r1, #128 //PWM_DIV_INTEGER
        mov r2, #0
        push {r0}
        bl Config_div_asm
        pop {r0}

        // Set top (wrap) value (Determines the frequency)
        ldr r1, =PWM_TOP_VALUE
        push {r0}
        bl Config_TOP_asm
        pop {r0}

        // Set zero duty
        mov r1, #0
        mov r2, #0
        push {r0}
        bl Config_CC_asm
        pop {r0}

        // Enable PWM
        mov r1, #1
        bl  Enable_PWM_asm
    // Infinite loop to take samples and send them to PWM channel
    loop: 
        //lextrura del gpio26(ADC0)
        mov r0, #0
        bl project_adc_read_asm
        mov r4, r0 // guardar el valor leido en r4(ADC0)

        //lextrura del gpio27(ADC1)
        mov r0, #1
        bl project_adc_read_asm
        mov r5, r0 // guardar el valor leido en r5(ADC1)

        // Interactuar con el serial monitor
        mov r0, r4
        mov r1, r5
        bl uart_text_Foto_Resistors

        // if  
            ldr r3, =MIN_VALUE_READ
            // Asumimos que r4 = photoResistor1, r5 = photoResistor2
            // r6 = PWM_MAX, r3 = ADC_MIN_READVALUE

            // Verificar si ambos valores están por debajo de la luz ambiente
            cmp r4, r3             // Comparar photoResistor1 con ADC_MIN_READVALUE(R3)
            bge check_motor2       // Saltar si r4 >= r3

            cmp r5, r3             // Comparar photoResistor2 con ADC_MIN_READVALUE(R3)
            bge check_motor2       // Saltar si r5 >= r3

            // Ambos valores están por debajo de la luz ambiente
            movs r4, #0            // pwm1 = 0
            movs r5, #0            // pwm2 = 0
            b next_loop            // Saltar al final de la rutina

            check_motor2:
                cmp r4, r5         // Comparar photoResistor1 (r4) con photoResistor2 (r5)
                bgt more_light1    // Si r4 > r5, saltar a more_light1
                blt more_light2    // Si r5 > r4, saltar a more_light2
    
            // Si r4 == r5 (ambos reciben la misma luz)
                movs r4, r4        // pwm1 = PWM_MAX
                movs r5, r5        // pwm2 = PWM_MAX
                b next_loop   // Saltar al final de la rutina
            
            // Si r4 recibe más luz que r5
            more_light1:
                movs r4, r4        // pwm1 = PWM_MAX
                movs r5, #0        // pwm2 = 0
                B next_loop   // Saltar al final de la rutina
            
            // Si r5 recibe más luz que r4
            more_light2:
                movs r4, #0        // pwm1 = 0
                movs r5, r5        // pwm2 = PWM_MAX

        //seguir con el loop
        next_loop: 
        // PWM counter compare level changer 1
            // Determine the PWM slice connected to GPIO: PWM_GPIO_CHA
            mov r0, #GPIO_PWM_1
            bl Cal_slices_asm
            // Set duty
            mov r1, #0
            mov r2, r4
            bl Config_CC_asm

        // PWM counter compare level changer 2
            // Determine the PWM slice connected to GPIO: PWM_GPIO_CHA
            mov r0, #GPIO_PWM_2
            bl Cal_slices_asm
            // Set duty
            mov r1, #0
            mov r2, r5
            bl Config_CC_asm
        
        // DELAY
            ldr r0, =Delay
            bl delay_asm 

        // Mantener el ciclo infinito
        b loop
    pop {r4, r5, pc}
.data



