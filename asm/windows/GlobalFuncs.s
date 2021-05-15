#if defined(_WIN32) || defined(__WIN32) || defined(_WIN64)

.section .text
    .global initInternalState

    //assuming the call is from windows, param 1 is stored in RCX and param 2 is stored in RDI
    //we just have to convert that call to a standard linux call
    //permormance hit is negligable because the vast majority of the calls are going to be from within asm itself and
    //call conversions from the standard asm implementation is unnecessary
    initInternalState:
        push %rdi
        push %rsi
        mov %rcx, %rdi
        mov %rdx, %rsi
        call initGBCpu
        pop %rsi
        pop %rdi
        ret

#endif