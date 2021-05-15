#include "CPU.h"

extern "C" {
    void initInternalState(void* instructions, int indexSize);
}

CPU::CPU() {
    initInternalState(instructions, sizeof(void*));
}