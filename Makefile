
AS = arm-none-eabi-gcc
CC = arm-none-eabi-gcc
CXX = arm-none-eabi-g++

ASFLAGS = -DARMCM3=1 -mcpu=cortex-m3 --specs=rdimon.specs -mthumb
CFLAGS = -DARMCM3=1 -mcpu=cortex-m3 --specs=rdimon.specs -mthumb -Iinclude -Iinclude/CMSIS/ -Iinclude/CMSIS/Core/
CXXFLAGS = -DARMCM3=1 -mcpu=cortex-m3 --specs=rdimon.specs -mthumb -Iinclude -Iinclude/CMSIS/ -Iinclude/CMSIS/Core/

CMSIS_OBJECT_LIST = \
	obj/CMSIS/startup_ARMCM3.o \
	obj/CMSIS/system_ARMCM3.o

SRC_OBJECT_LIST = \
	obj/main.o

all: bin/binary.bin

bin/binary.bin: $(CMSIS_OBJECT_LIST) $(SRC_OBJECT_LIST)
	$(info linking...)
	@arm-none-eabi-gcc -mcpu=cortex-m3 --specs=rdimon.specs -mthumb -g -T gcc_arm.ld $(CMSIS_OBJECT_LIST) $(SRC_OBJECT_LIST) -o bin/binary.elf
	@arm-none-eabi-objcopy -O binary bin/binary.elf bin/binary.bin

############# source/CMSIS ###########

obj/CMSIS/%.o: source/CMSIS/%.S
	$(info compiling $< -> $@)
	@$(AS) $(ASFLAGS) -Os -c $< -o $@

obj/CMSIS/%.o: source/CMSIS/%.c
	$(info compiling $< -> $@)
	@$(CC) $(CFLAGS) -Os -c $< -o $@

obj/CMSIS/%.o: source/CMSIS/%.cpp
	$(info compiling $< -> $@)
	@$(CXX) $(CXXFLAGS) -Os -c $< -o $@

############# source ###########

obj/%.o: source/%.c
	$(info compiling $< -> $@)
	@$(CC) $(CFLAGS) -c $< -o $@

obj/%.o: source/%.cpp
	$(info compiling $< -> $@)
	@$(CXX) $(CXXFLAGS) -c $< -o $@

############# source dependencies ###########

obj/main.o: include/CMSIS/ARMCM3.h
