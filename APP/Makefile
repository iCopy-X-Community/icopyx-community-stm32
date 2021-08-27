CROSS  ?= arm-none-eabi-
CC = $(CROSS)gcc
CXX = $(CROSS)g++
#LD = $(CROSS)ld
LD=$(CXX)

INCLUDE = -I ../HARDWARE/DMA -I ../HARDWARE/ICOPYX_BSP -I ../HARDWARE/LCD -I ../HARDWARE/SPI -I ../STM32F10x_FWLib/inc -I ../SYSTEM/delay -I ../SYSTEM/sys -I ../SYSTEM/usart -I USER -I ../HARDWARE/W25QXX -I ../SYSTEM/KombiFs -I ../SYSTEM/COMMPROC -I ../HARDWARE/ADC -I ../HARDWARE/KEY -I ../HARDWARE/TIMER -I ../HARDWARE/IIC -I ../CORE -I ../HARDWARE/AW87319 -I ../HARDWARE/AW87318 -I ../SYSTEM/debugflag/

OBJDIR = obj
VPATH = USER ../SYSTEM/KombiFs ../SYSTEM/delay ../SYSTEM/sys ../SYSTEM/usart ../HARDWARE/W25QXX ../HARDWARE/LCD ../HARDWARE/SPI ../HARDWARE/ICOPYX_BSP ../HARDWARE/DMA ../STM32F10x_FWLib/src ../CORE ../SYSTEM/COMMPROC ../HARDWARE/ADC ../HARDWARE/KEY ../HARDWARE/TIMER ../HARDWARE/IIC ../HARDWARE/AW87318 $(OBJDIR)

SRC_S = startup_stm32f10x_md.s
SRC_C = adc.c AW87318.c ICOPYX_IMAGE.c myiic.c key.c timer.c
SRC_C += stm32f10x_adc.c stm32f10x_bkp.c stm32f10x_dma.c stm32f10x_exti.c stm32f10x_flash.c stm32f10x_gpio.c stm32f10x_pwr.c stm32f10x_rcc.c stm32f10x_spi.c stm32f10x_tim.c stm32f10x_usart.c
SRC_C += core_cm3.c
SRC_C += dma.c ICOPYX_BSP.c ST7789.c ST7789_init.c spi.c w25qxx.c misc.c
SRC_C += sys_command_line.c sys_queue.c delay.c KombiFs.c sys.c usart.c
SRC_C += APP.c BspTime.c stm32f10x_it.c system_stm32f10x.c

# USE_RTC=0 to compile tag v1.0
USE_RTC=1
ifeq ($(USE_RTC),1)
    INCLUDE+=-I ../HARDWARE/RTC
    VPATH+=../HARDWARE/RTC
    SRC_C+=rtc.c stm32f10x_rtc.c
endif

OBJS = $(SRC_S:%.s=$(OBJDIR)/%.o)
OBJS += $(SRC_C:%.c=$(OBJDIR)/%.o)

COMMONFLAGS = -mthumb -mcpu=cortex-m3 -mfloat-abi=soft -march=armv7-m
CFLAGS= -ffunction-sections -fdata-sections
# VisualStudio is using -ggdb, no need for now
#CFLAGS += -ggdb
# VisualStudio is using -O0
#CFLAGS += -O0
# But our image is too large, so we use -Os
CFLAGS += -Os
DEFCFLAGS = -DDEBUG=1 -DUSE_STDPERIPH_DRIVER -DSTM32F10X_MD
# VisualStudio seems to define it but not visible in the VS logs?
#DEFCFLAGS += -DHW_V16
DEFCFLAGS += -DARM_MATH_CM3 -Dflash_layout -DSTM32F103C8
LDFLAGS=-Wl,--gc-sections --specs=nano.specs --specs=nosys.specs

all: $(OBJDIR)/icopy_stm32_VS.bin

clean:
	rm -rf $(OBJDIR)

$(OBJDIR):
	mkdir -p $(OBJDIR)

%.o : %.s
$(OBJDIR)/%.o : %.s | $(OBJDIR)
	$(info [-] CXX $<)
	$(CXX) $(COMMONFLAGS) $(CFLAGS) $(DEFCFLAGS) $(INCLUDE) -c -o $@ $<

%.o : %.c
$(OBJDIR)/%.o : %.c | $(OBJDIR)
	$(info [-] CC $<)
	$(CC) $(COMMONFLAGS) $(CFLAGS) $(DEFCFLAGS) $(INCLUDE) -c -o $@ $<

$(OBJDIR)/icopy_stm32_VS.elf: $(OBJS)
	$(CC) -o $@ $(COMMONCFLAGS) $(LDFLAGS) -Wl,-T,"STM32F103C8_flash.lds",-Map,$(patsubst %.elf,%.map,$@) $^

%.bin : %.elf
	arm-none-eabi-objcopy --gap-fill=0xff --pad-to 0x0800B400 -O binary $< $@

.PHONY: all
