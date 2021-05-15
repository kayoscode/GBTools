cmake_minimum_required(VERSION 3.0)

set(PROJ_NAME GBTools)
project(${PROJ_NAME} CXX ASM)

file(GLOB SRC
    "src/*.cpp"
    "include/*.h"
    "asm/*.s"
    "asm/windows/*.s"
    "asm/linux/*.s"
)

add_executable(${PROJ_NAME}
    "${SRC}"
)

set(ASM_OPTIONS "-x assembler-with-cpp")
set(CMAKE_ASM_FLAGS "${CFLAGS} ${ASM_OPTIONS}")

target_include_directories("${PROJ_NAME}" PRIVATE ${PROJECT_SOURCE_DIR}/./include)