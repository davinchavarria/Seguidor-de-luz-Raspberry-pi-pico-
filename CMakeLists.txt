cmake_minimum_required(VERSION 3.13)

# Always include it
include(pico_sdk_import.cmake)

# Project's name 
project(pwmAdcC C CXX)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# SDK Initialization - Mandatory
pico_sdk_init()

# C/C++ project files
add_executable(pwmAdcC
    src/main.c
    src/main.s
    src/adc.s
    src/adc.c 
    src/gpio.s 
    src/pwm.c
    src/pwm.s
    src/uart.s

)

# Header folder
include_directories(include)

# pico_stdlib library. You can add more if they are needed
target_link_libraries(pwmAdcC pico_stdlib hardware_adc hardware_pwm)

# Enable usb output, disable uart output
pico_enable_stdio_usb(pwmAdcC 1)
pico_enable_stdio_uart(pwmAdcC 0)

# Need to generate UF2 file for upload to RP2040
pico_add_extra_outputs(pwmAdcC)