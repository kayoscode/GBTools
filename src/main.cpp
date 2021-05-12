#include <iostream>

/**
 * C calling documentation
 * http://6.s081.scripts.mit.edu/sp18/x86-64-architecture-guide.html
 * http://marc.rawer.de/Gameboy/Docs/GBCPUman.pdf
 * */

extern "C" {
    int add(int a, int b);
    int test1(int a);
}

int main() {
    int a = 100;
    int b = 10;
    int c = add(a, b);

    std::cout << c << "\n";
    return 0;
}