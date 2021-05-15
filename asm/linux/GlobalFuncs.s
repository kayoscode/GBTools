#if defined(__unix) || defined(__unix__)

.section .text
    .global initInternalState

    //for linux, call translation is unncessary because 
    initInternalState:
        call initGBCpu
        ret

#endif