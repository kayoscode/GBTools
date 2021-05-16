#include "CPU.h"
#include <bitset>

constexpr int AF = 0;
constexpr int BC = 1;
constexpr int DE = 2;
constexpr int HL = 3;
constexpr int SP = 4;
constexpr int PC = 5;

void printCPUState() {
    std::cout << "AF: " << currentCPUState[AF] << " " << ((currentCPUState[AF] & 0xFF00) >> 8) << " " << (currentCPUState[AF] & 0xFF) << "\n";
    std::cout << "BC: " << currentCPUState[BC] << " " << ((currentCPUState[BC] & 0xFF00) >> 8) << " " << (currentCPUState[BC] & 0xFF) << "\n";
    std::cout << "DE: " << currentCPUState[DE] << " " << ((currentCPUState[DE] & 0xFF00) >> 8) << " " << (currentCPUState[DE] & 0xFF) << "\n";
    std::cout << "HL: " << currentCPUState[HL] << " " << ((currentCPUState[HL] & 0xFF00) >> 8) << " " << (currentCPUState[HL] & 0xFF) << "\n";
    std::cout << "SP: " << currentCPUState[SP] << "\n";
    std::cout << "PC: " << currentCPUState[PC] << "\n";
    std::cout << "\n";
}

CPU::CPU() {
    //set initial cpu state
    currentCPUState[AF] = 0;
    currentCPUState[BC] = 0;
    currentCPUState[DE] = 0;
    currentCPUState[HL] = 0;
    currentCPUState[SP] = 0;
    currentCPUState[PC] = 0;

    initInternalState(instructions, sizeof(void*));
}