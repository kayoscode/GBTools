#include "defs.s"
#include "memoryMacros.s"

//http://gameboy.mongenel.com/dmg/asmmemmap.html -> memory map detailed
//memory modes: 

.section .data
    //stores an array containing all data for main memory [0x00-0xFFFF] size
    //uint8_t mainMemoryData[0x10000] = { 0 };
    /**
     * MEMORY MAP:
     * 0xFFFF Interrupt Enable Register
     * 0xFF80 Internal RAM
     * 0xFF4C Empty but usable IO ports
     * 0xFF00 IO Ports
     * 0xFEA0 Empty but usable IO ports
     * 0xFE00 Sprite Attrib Memory (OAM)
     * 0xE000 Echo of 8kb internal RAM
     * 0xC000 8kb Internal RAM
     * 0xA000 8kb switchable ram bank
     * 0x8000 8kb video ram
     * 0x4000 16kb switchable ROM bank
     * 0x0000 16kb ROM bank #0
     */
    .global memoryMap
    mainMemory:
        .space 0x10000, 0

/**
 * MBC1 write modes
 * 0000-3FFF: ROM bank (Read only)
 * 4000-7FFF: Additional ROM banks (read only)
 * A000-BFFF: RAM bank - if present (Read/write)
 * 
 * Writing to *ROM interpretations
 * 0000-1FFF: writing anything with 0xXA in this area enables RAM
 * 2000-3FFF: writing to this area sets the rom bank number (5 bits) 0->1 20->21, 40->41, 60->61
 * 6000-7FFF: writing either 0 or 1 to this area sets the MBC mode
    2modes: 16MB ROM/8kb RAM and 4MB ROM/32kb ram
 * 4000-5FFF: 
 */

.section .text
    //ROM ONLY
    ROMOnlyMemRead:
        ret

    ROMOnlyMemWrite:
        ret

    //MBC1
    MBC1MemWrite:
        ret

    MBC1MemRead:
        ret