HOST_OPENOCD := LPC54018
NAME := mcu_lpc54018impl

$(NAME)_MBINS_TYPE := kernel
$(NAME)_VERSION    := 1.0.0
$(NAME)_SUMMARY    := driver & sdk for platform/mcu lpc54018impl

$(NAME)_COMPONENTS += arch_armv7m
$(NAME)_COMPONENTS += rhino newlib_stub

GLOBAL_CFLAGS  += -DA_LITTLE_ENDIAN
GLOBAL_CFLAGS  += -DCPU_LPC54018JET180

ifeq ($(COMPILER),iar)
GLOBAL_CFLAGS   += --cpu=Cortex-M4  \
                   --cpu_mode=thumb \
                   --endian=little
GLOBAL_LDFLAGS  += --silent --cpu=Cortex-M4.vfp
GLOBAL_LDFLAGS += -Lplatform/mcu/lpc54018/iar/
GLOBAL_LDFLAGS += -liar_power
GLOBAL_LDFLAGS  += --config platform/mcu/lpc54018/iar/LPC54018_spifi_flash.icf
else ifeq ($(COMPILER), armcc)
GLOBAL_INCLUDES += ../../arch/arm/armv7m/armcc/m4/
GLOBAL_ASMFLAGS +=  -c --cpu Cortex-M4.fp --apcs=interwork
GLOBAL_CFLAGS +=  --c99 -c --cpu Cortex-M4.fp -D__EVAL -g --apcs=interwork --split_sections
GLOBAL_LDFLAGS += --cpu=Cortex-M4.fp
GLOBAL_LDFLAGS += -L --scatter=platform/mcu/lpc54018/arm/LPC54018_spifi_flash.scf
GLOBAL_LDFLAGS += -L platform/mcu/lpc54018/arm/keil_lib_power.lib
else
GLOBAL_CFLAGS   += -Wall -fno-common -ffunction-sections -fdata-sections -ffreestanding -fno-builtin -mthumb -mapcs -std=gnu99
GLOBAL_CFLAGS   += -mcpu=cortex-m4 -mfloat-abi=hard -MMD -MP -mfpu=fpv4-sp-d16
GLOBAL_CFLAGS   += -Wno-format -Wno-incompatible-pointer-types

GLOBAL_ASMFLAGS += -Wall -fno-common -ffunction-sections -fdata-sections -ffreestanding -fno-builtin -mthumb -mapcs -std=gnu99
GLOBAL_ASMFLAGS += -D__STARTUP_CLEAR_BSS

GLOBAL_ASMFLAGS += -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16

GLOBAL_LDFLAGS  += -Lplatform/mcu/lpc54018/gcc/
GLOBAL_LDFLAGS  += -lpower_hardabi
GLOBAL_LDFLAGS  += --specs=nano.specs --specs=nosys.specs
GLOBAL_LDFLAGS  += -Wall -fno-common -ffunction-sections -fdata-sections -ffreestanding -fno-builtin -mthumb -mapcs
GLOBAL_LDFLAGS  += -Xlinker --gc-sections -Xlinker -static -Xlinker -z -Xlinker muldefs
GLOBAL_LDFLAGS  += -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
GLOBAL_LDFLAGS  += -T platform/mcu/lpc54018/gcc/LPC54018_spifi_flash.ld

$(NAME)_CFLAGS  += -Wall -Werror -Wno-unused-variable -Wno-unused-parameter -Wno-implicit-function-declaration
$(NAME)_CFLAGS  += -Wno-type-limits -Wno-sign-compare -Wno-pointer-sign -Wno-uninitialized
$(NAME)_CFLAGS  += -Wno-return-type -Wno-unused-function -Wno-unused-but-set-variable
$(NAME)_CFLAGS  += -Wno-unused-value -Wno-strict-aliasing
endif

GLOBAL_INCLUDES += ./ \
                   CMSIS/Include \
                   drivers

$(NAME)_SOURCES :=

#$(NAME)_SOURCES     += ../../arch/arm/armv7m/gcc/m4/port_c.c
#$(NAME)_SOURCES     += ../../arch/arm/armv7m/gcc/m4/port_s.S

$(NAME)_SOURCES += ./drivers/fsl_clock.c
$(NAME)_SOURCES += ./drivers/fsl_common.c
$(NAME)_SOURCES += ./drivers/fsl_dma.c
$(NAME)_SOURCES += ./drivers/fsl_emc.c
$(NAME)_SOURCES += ./drivers/fsl_flexcomm.c
$(NAME)_SOURCES += ./drivers/fsl_inputmux.c
$(NAME)_SOURCES += ./drivers/fsl_gpio.c
$(NAME)_SOURCES += ./drivers/fsl_pint.c
$(NAME)_SOURCES += ./drivers/fsl_reset.c
$(NAME)_SOURCES += ./drivers/fsl_spifi.c
$(NAME)_SOURCES += ./drivers/fsl_power.c
$(NAME)_SOURCES += ./drivers/fsl_usart.c
$(NAME)_SOURCES += ./system_LPC54018.c

ifeq ($(COMPILER),iar)
$(NAME)_SOURCES += ./iar/startup_LPC54018.s
else ifeq ($(COMPILER), armcc)
$(NAME)_SOURCES += ./arm/startup_LPC54018.s
$(NAME)_LINK_FILES := ./arm/startup_LPC54018.o
else
$(NAME)_SOURCES += ./gcc/startup_LPC54018.S
endif

$(NAME)_SOURCES += ./hal/hal_uart.c
$(NAME)_SOURCES += ./hal/hal_flash.c

$(NAME)_SOURCES += ./aos/aos.c
$(NAME)_SOURCES += ./aos/soc_impl.c

