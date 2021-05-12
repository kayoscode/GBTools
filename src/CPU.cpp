#include "CPU.h"

extern "C" {
    void initGBCpu(void* instructions, int indexSize);
}

CPU::CPU() {
    initGBCpu(instructions, sizeof(void*));
}