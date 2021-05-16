#if defined(_WIN32) || defined(__WIN32) || defined(_WIN64)

.section .text
    .global initInternalState
    .global testCPU

    //assuming the call is from windows, param 1 is stored in RCX and param 2 is stored in RDI
    //we just have to convert that call to a standard linux call
    //permormance hit is negligable because the vast majority of the calls are going to be from within asm itself and
    //call conversions from the standard asm implementation is unnecessary
    initInternalState:
        push %rbp
        mov %rsp, %rbp

        push %rdi
        push %rsi
        mov %rcx, %rdi
        mov %rdx, %rsi

        push %R12
        push %R13
        push %R14
        push %R15

        and $-16, %rsp
        call initGBCpu

        pop %R15
        pop %R14
        pop %R13
        pop %R12

        pop %rsi
        pop %rdi

        leave
        ret

#endif