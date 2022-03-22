# Version: $Id: Makefile 920 2011-11-09 23:52:27Z ag0015 $

PRG = group_28
OBJ = $(PRG).o get_digit.o init.o check_letter.o


MCU_TARGET = atmega328p
#OPTIMIZE = -Os
OPTIMIZE = -O0

DEFS =
LIBS =

CC = avr-gcc
AS = avr-gcc

CFLAGS = -g -Wall $(OPTIMIZE) -mmcu=$(MCU_TARGET) $(DEFS)
LDFLAGS = -g -Wall $(OPTIMIZE) -mmcu=$(MCU_TARGET) -nostdlib $(DEFS)
AFLAGS = -g -Wall -mmcu=$(MCU_TARGET) $(DEFS) -c


OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump

all: hex ehex

# dependencies:
$(PRG).o: $(PRG).S 7segment.S
get_digit.o: 7segment.S


# compiling is done by an implicit rule.

# assembling:

%.o: %.S
	$(AS) $(AFLAGS) -o $@ $<

#linking:
$(PRG).elf: $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)



clean:
	rm -rf *.o $(PRG).elf
	rm -rf *.lst *.map $(EXTRA_CLEAN_FILES)

lst: $(PRG).lst

%.lst: %.elf
	$(OBJDUMP) -h -S $< > $@

# Rules for building the .text rom images
hex: $(PRG).hex

%.hex: %.elf
	$(OBJCOPY) -j .text -O ihex $< $@
#	$(OBJCOPY) -j .text -j .data -O ihex $< $@

# Rules for building the .eeprom rom images
ehex: $(PRG)_eeprom.hex

%_eeprom.hex: %.elf
	$(OBJCOPY) -j .eeprom --change-section-lma .eeprom=0 -O ihex $< $@ || { echo empty $@ not generated; exit 0; }

# Rules for Uploading to the Arduino board:
upload: all
	avrdude -p m328p -c arduino -P /dev/ttyACM0 -Uflash:w:$(PRG).hex
