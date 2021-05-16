#include <iostream>
#include "CPU.h"
#include <chrono>

class Timer{
    public:
        Timer(){
            reset();
        }

        ~Timer(){}

        inline void reset(){
            this->prevTP = std::chrono::high_resolution_clock::now();
        }

        inline long nanoseconds(){
            auto now = std::chrono::high_resolution_clock::now();
            return (long)std::chrono::duration_cast<std::chrono::nanoseconds>(now - prevTP).count();
        }

        inline long microseconds(){
            auto now = std::chrono::high_resolution_clock::now();
            return (long)std::chrono::duration_cast<std::chrono::microseconds>(now - prevTP).count();
        }

        inline long milliseconds(){
            auto now = std::chrono::high_resolution_clock::now();
            return (long)std::chrono::duration_cast<std::chrono::milliseconds>(now - prevTP).count();
        }

        inline long seconds(){
            auto now = std::chrono::high_resolution_clock::now();
            return (long)std::chrono::duration_cast<std::chrono::seconds>(now - prevTP).count();
        }

    private:
        std::chrono::high_resolution_clock::time_point prevTP;
};

int main() {
    Timer t;
    CPU cpu;
    cpu.executeInstruction(4);
    std::cout << "Elapsed milliseconds: " << t.milliseconds() << "\n";

    return 0;
}