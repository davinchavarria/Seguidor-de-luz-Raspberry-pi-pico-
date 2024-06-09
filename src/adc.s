.global project_adc_init_asm
project_adc_init_asm:  
    push {r0, lr}
     //inicializamos todos los pueros adc
    bl adc_init_wrapper 
    //configurar el GPIO 26 para ADC
    mov r0, #26
    bl adc_gpio_init_wrapper
    //configurar el GPIO 27 para ADC
    mov r0, #27
    bl adc_gpio_init_wrapper
    pop {r0, pc}

  
.global project_adc_read_asm
project_adc_read_asm:
    push {lr}
    // Selecciona el canal ADC a leer el valor 
    //mov r0, #0 o mov r0, #1 --> lo cogemos como parametro 
    bl adc_select_input_wrapper
    bl adc_read_wrapper
    pop {pc}