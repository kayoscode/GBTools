#ifndef INCLUDE_CPU_H
#define INCLUDE_CPU_H

#include <iostream>

/**
 * C calling documentation
 * http://6.s081.scripts.mit.edu/sp18/x86-64-architecture-guide.html
 * http://marc.rawer.de/Gameboy/Docs/GBCPUman.pdf
 * */

class CPU {
    public:
        CPU();

        inline void executeInstruction(int opcode) {
            int v = instructions[opcode](0);
            std::cout << v << "\n";
        }

    private:
        int (*instructions[256])(int p1) = { 0 };
};

#endif