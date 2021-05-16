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

        push %rcx
        push %rdi
        call saveCPUState
        call printCPUState
        call loadCPUState
        pop %rdi
        pop %rcx

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
        moveUpperRegToTemp BC, %rdi

        //start by clearing all flags except carry (unaffected)
        and $0x1F, F

        //perform actual increment on register (add instruction to make sure it sets the auxilliary flag)
        add $1, %dil
        calcSetHalfCarry
        calcSetZero %dil

        //copy back into base register
        shl $8, %di
        or %di, BCW
        ret
    
    //dec B
    .global inst0x05
    inst0x05:
        moveUpperRegToTemp BC, %rdi

        //start by clearing all flags except carry (unaffected)
        and $0x1F, F

        //sub and calculate flags
        sub $1, %dil
        calcSetHalfCarry
        calcSetZero %dil
        setSub

        //copy back into register
        shl $8, %di
        or %di, BCW
        ret
    
    //LD B, d8
    .global inst0x06
    inst0x06:
        ret;

    //RLCA
    //Rotate A left. Old bit 7 to carry flag
    .global inst0x07
    inst0x07:
        moveUpperRegToTemp AF, %rdi

        //start by clearing flag register
        xor F, F

        //set carry flag to current bit 7
        mov %rdi, %rcx
        and $0x80, %rcx
        shr $3, %rcx
        or %rcx, AF

        shl $1, %di

        //set least significant bit if carry flag is set
        //TODO: MAKE SURE THIS IS CORRECT, IDK WTF THIS IS SUPPOSED TO DO
        shr $4, %rcx
        or %rcx, %rdi

        calcSetZero %dil

        shl $8, %di
        or %di, AFW
        ret

    //LD (a16), SP
    .global inst0x08
    inst0x08:
        ret;

    //ADD HL, BC
    .global inst0x09
    inst0x09:
        ret;

    //LD A, (BC)
    .global inst0x0A
    inst0x0A:
        ret;

    //DEC BC
    .global inst0x0B
    inst0x0B:
        dec BC
        and $0xFFFF, BC
        ret
    
    //INC C
    .global inst0x0C
    inst0x0C:
        moveLowerToTemp BC, %rdi

        //start by clearing all flags except carry (unaffected)
        and $0x1F, F

        //perform actual increment on register (add instruction to make sure it sets the auxilliary flag)
        add $1, %dil
        calcSetHalfCarry
        calcSetZero %dil

        //copy back into base register
        or %di, BCW
        ret
    
    //DEC C
    .global inst0x0D
    inst0x0D:
        moveLowerToTemp BC, %rdi

        //start by clearing all flags except carry (unaffected)
        and $0x1F, F

        //sub and calculate flags
        sub $1, %dil
        calcSetHalfCarry
        calcSetZero %dil
        setSub

        //copy back into register
        or %di, BCW
        ret
    
    //LD C, d8
    .global inst0x0E
    inst0x0E:
        ret

    //RRCA
    .global inst0x0F
    inst0x0F:
        ret

    //STOP 0
    .global inst0x10
    inst0x10:
        ret

    //initGBCpu(rdi: void* instructions, rsi:int size)
    //function initializes the array of opcodes
    initGBCpu:
        push %rbp
        mov %rsp, %rbp

        pushq %rdx
        //move each instruction into the array in proper order
        //also fill the instructionArr
        leaq instructionArr(%rip), %rdx

        //0x
        addop inst0x00
        addop inst0x01
        addop inst0x02
        addop inst0x03
        addop inst0x04
        addop inst0x05
        addop inst0x06
        addop inst0x07
        addop inst0x08
        addop inst0x09
        addop inst0x0A
        addop inst0x0B
        addop inst0x0C
        addop inst0x0D
        addop inst0x0E
        addop inst0x0F

        //1x
        addop inst0x10

        call loadCPUState
        mov $0xFF00, AF
        call inst0x07
        call printInternalState

        popq %rdx

        leave
        ret