#include "defs.s"

//https://cs.lmu.edu/~ray/notes/gasexamples/
//data bytes: https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_chapter/as_7.html
.section .data
    .balign 8

    instructionArr:
        .space 8 * 1024, 0

    //stores values of registers
    //used for transitioning between C and ASM
    //uint64_t*
    .global currentCPUState
    currentCPUState:
        .quad 0, 0, 0, 0, 0, 0

.section .text
    .global initGBCpu
    .global loadCPUState
    .extern printCPUState

    //void printInternalState()
    //preserves state and prints using c++
    printInternalState:
        //set stack frame
        push %rbp
        mov %rsp, %rbp
        //here we would allocate space for local variables if necessary

        //ensure byte alignment
        and $-16, %rsp

        call saveCPUState
        call printCPUState
        call loadCPUState

        //return
        leave
        ret

    //takes the current values in CPU state and initializes each 
    //cpu register
    loadCPUState:
        leaq currentCPUState(%rip), %rcx
        mov 0 * REGISTER_SIZE_BYTE(%rcx), AF
        mov 1 * REGISTER_SIZE_BYTE(%rcx), BC
        mov 2 * REGISTER_SIZE_BYTE(%rcx), DE
        mov 3 * REGISTER_SIZE_BYTE(%rcx), HL
        mov 4 * REGISTER_SIZE_BYTE(%rcx), SP
        mov 5 * REGISTER_SIZE_BYTE(%rcx), PC
        ret
    
    //takes the current register state and loads it into the array
    saveCPUState:
        leaq currentCPUState(%rip), %rcx
        mov AF, 0 * REGISTER_SIZE_BYTE(%rcx)
        mov BC, 1 * REGISTER_SIZE_BYTE(%rcx)
        mov DE, 2 * REGISTER_SIZE_BYTE(%rcx)
        mov HL, 3 * REGISTER_SIZE_BYTE(%rcx)
        mov SP, 4 * REGISTER_SIZE_BYTE(%rcx)
        mov PC, 5 * REGISTER_SIZE_BYTE(%rcx)
        ret

    //NOP
    .global inst0x00
    inst0x00:
        ret

    //LD BC, d16
    .global inst0x01
    inst0x01:
        ret

    //LD (BC), A
    .global inst0x02
    inst0x02:
        ret

    //inc BC
    .global inst0x03
    inst0x03:
        inc BC //doesn't affect flags 
        and $0xFFFF, BC //might not care about this because the overflow doesn't matter
        ret

    //inc B (RDI, RSI, RCX, RDX modified)
    .global inst0x04
    inst0x04:
        //move to temp register and increment
        mov BC, %rdi
        and $0x00FF, BC
        shr $8, %rdi

        //copy the previous flag register to rsi
        //be sure to clear the bits that will be modified
        and $0x1F, F

        //perform actual increment on register (add instruction to make sure it sets the auxilliary flag)
        add $1, %dil
        calcSetHalfCarry
        calcSetZero %dil

        //copy back into base register
        shl $8, %di
        or %di, BCW

        ret

    //initGBCpu(rdi: void* instructions, rsi:int size)
    //function initializes the array of opcodes
    initGBCpu:
        pushq %rdx
        //move each instruction into the array in proper order
        //also fill the instructionArr
        leaq instructionArr(%rip), %rdx

        addop inst0x00
        addop inst0x01
        addop inst0x02
        addop inst0x03
        addop inst0x04

        popq %rdx
        ret