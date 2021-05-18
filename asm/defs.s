#ifndef INCLUDE_DEFS_S
#define INCLUDE_DEFS_S

#define AF %R10
#define BC %R11
#define DE %R12
#define HL %R13
#define SP %R14
#define PC %R15
#define F %R10b
#define C %R11b
#define E %R12b
#define C %R11b
#define AFW %R10w
#define BCW %R11w
#define DEW %R12w
#define HLW %R13w
#define SPw %R14w
#define PCw %R15w

#define REGISTER_SIZE_BYTE 8

#define ZERO_FLAG_MASK $128
#define SUB_FLAG_MASK $64
#define HALF_CARRY_FLAG_MASK $32
#define CARRY_FLAG_MASK $16

#define COMP_ZERO_FLAG_MASK $127
#define COMP_SUB_FLAG_MASK $191
#define COMP_HALF_CARRY_FLAG_MASK $223
#define COMP_CARRY_FLAG_MASK $239

#define NONE_INTERRUPT 0x00
#define VBLANK_INTERRUPT 0x01
#define LCDSTAT_INTERRUPT 0x02
#define TIMER_INTERRUPT 0x04
#define SERIAL_INTERRUPT 0x08
#define JOYPAD_INTERRUPT 0x10

//zero flag (Z) -> set if the result of the last operation turned out to be zero
//subtract flag (N) -> set if subtraction was performed in the last math op
//half carry flag (H) -> set if a carry occured in the lower nibble (last op)
//carry flag (C) -> set if a carry occured from the last math op OR if register A is the smaller value when executing CP instruction
.macro setZero
    or ZERO_FLAG_MASK, F
.endm

.macro clearZero
    and COMP_ZERO_FLAG_MASK, F
.endm

.macro branchZero flagMask lbl
.endm

.macro setSub
    or SUB_FLAG_MASK, F
.endm

.macro clearSub
    and COMP_SUB_FLAG_MASK, F
.endm

.macro setHalfCarry
    or HALF_CARRY_FLAG_MASK, F
.endm

.macro clearHalfCarry
    and COMP_HALF_CARRY_FLAG_MASK, F
.endm

.macro setCarry
    or CARRY_FLAG_MASK, F
.endm

.macro clearCarry
    and COMP_CARRY_FLAG_MASK, F
.endm

//adds an opcode to the array of functions
.macro addop lbl
    leaq \lbl (%rip), %rcx
    mov %rcx, 0(%rdi)
    mov %rcx, 0(%rdx)
    add %rsi, %rdi
    add %rsi, %rdx
.endm

//only modifies RDX but sets AF properly
.macro calcSetHalfCarry
    pushfq
    pop %rdx
    and $0x10, %rdx
    shl $1, %rdx //shifting left by one lines rdx up with the gameboy's half carry flag
    or %rdx, AF
.endm

//modifies RCX and RDX
.macro calcSetZero register
    //set zero flag if applicable
    xor %rdx, %rdx
    cmp $0, \register
    mov ZERO_FLAG_MASK, %rcx
    cmove %rcx, %rdx
    or %rdx, AF
.endm

.macro moveUpperRegToTemp register, dest
    mov \register, \dest
    and $0x00FF, \register
    shr $8, \dest
.endm

.macro moveLowerToTemp register, dest
    mov \register, \dest
    and $0xFF00, \register
.endm

.macro incDblReg register
    inc \register //doesn't affect flags 
    and $0xFFFF, \register //might not care about this because the overflow doesn't matter
.endm

.macro decDblReg register
    dec \register
    and $0xFFFF, \register
.endm

.macro decLowReg register, store
    moveLowerToTemp \register, %rdi

    //start by clearing all flags except carry (unaffected)
    and $0x1F, F

    //sub and calculate flags
    sub $1, %dil
    calcSetHalfCarry
    calcSetZero %dil
    setSub

    //copy back into register
    or %di, \store
.endm

.macro incLowReg register, store
    moveLowerToTemp \register, %rdi

    //start by clearing all flags except carry (unaffected)
    and $0x1F, F

    //perform actual increment on register (add instruction to make sure it sets the auxilliary flag)
    add $1, %dil
    calcSetHalfCarry
    calcSetZero %dil

    //copy back into base register
    or %di, \store
.endm

.macro decHighReg register, store
    moveUpperRegToTemp \register, %rdi

    //start by clearing all flags except carry (unaffected)
    and $0x1F, F

    //sub and calculate flags
    sub $1, %dil
    calcSetHalfCarry
    calcSetZero %dil
    setSub

    //copy back into register
    shl $8, %di
    or %di, \store
.endm

.macro incHighReg register, store
    moveUpperRegToTemp \register, %rdi

    //start by clearing all flags except carry (unaffected)
    and $0x1F, F

    //perform actual increment on register (add instruction to make sure it sets the auxilliary flag)
    add $1, %dil
    calcSetHalfCarry
    calcSetZero %dil

    //copy back into base register
    shl $8, %di
    or %di, \store
.endm

#endif