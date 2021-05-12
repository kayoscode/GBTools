.section .text
    .global add
    .global test1

    add:
        add %rdi, %rsi
        mov %rsi, %rax
        ret

    test1:
        add $1000, %rdi
        mov %rdi, %rax
        ret