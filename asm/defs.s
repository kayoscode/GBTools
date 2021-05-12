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

#define ZERO_FLAG_MASK $128
#define SUB_FLAG_MASK $64
#define HALF_CARRY_FLAG_MASK $32
#define CARRY_FLAG_MASK $16

#define COMP_ZERO_FLAG_MASK $127
#define COMP_SUB_FLAG_MASK $191
#define COMP_HALF_CARRY_FLAG_MASK $223
#define COMP_CARRY_FLAG_MASK $239

//zero flag (Z) -> set if the result of the last operation turned out to be zero
//subtract flag (N) -> set if subtraction was performed in the last math op
//half carry flag (H) -> set if a carry occured in the lower nibble (last op)
//carry flag (C) -> set if a carry occured from the last math op OR if register A is the smaller value when executing CP instruction
.macro setFlag flagMask
    or \flagMask, F
.endm

.macro clearFlag flagMask
    and \flagMask, F
.endm

.macro branchZero flagMask lbl
.endm

//adds an opcode to the array of functions
.macro addop lbl
    leaq \lbl (%rip), %rcx
    mov %rcx, 0(%rdi)
    mov %rcx, 0(%rdx)
    add %rsi, %rdi
    add %rsi, %rdx
.endm

#endif