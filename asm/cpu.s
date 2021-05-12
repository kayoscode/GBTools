#include "defs.s"

//https://cs.lmu.edu/~ray/notes/gasexamples/
//data bytes: https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_chapter/as_7.html
.section .data
    .balign 8
    instructionArr:
        .space 8 * 1024, 0

.section .text

    .global initGBCpu

    //NOP
    inst0x00:
        mov $0, %rax
        ret

    //LD BC, d16
    inst0x01:
        mov $1, %rax
        ret

    //LD (BC), A
    inst0x02:
        ret

    //inc BC
    inst0x03:
        inc BC //doesn't affect flags 
        and $0xFFFF, BC //might not care about this because the overflow doesn't matter
        ret

    //inc B
    inst0x04:
        add $0x100, BC
        and $0xFFFF, BC

        shrd $1, BC, %rcx
        cmp $0, %rcx
        jne inst0x04SkipZeroFlag
        setZero
        inst0x04SkipZeroFlag:

        //if the result is zero, set the zero flag
        clearSub

        //TODO: set other flags accordingly and set zero flag to false in the ELSE condition
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