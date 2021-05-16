#if defined(__unix) || defined(__unix__)

.section .text

    //for linux, call translation is unncessary because 
    //initInternalState(void* functions, int sizeof(void*))
    .global initInternalState
    initInternalState:
        push %rbp
        mov %rsp, %rbp

        push %rcx
        push %rdx
        push %R12
        push %R13
        push %R14
        push %R15

        and $-16, %rsp
        call initGBCpu

        pop %r12
        pop %r13
        pop %r14
        pop %R15
        pop %rdx
        pop %rcx

        leave
        ret

#endif