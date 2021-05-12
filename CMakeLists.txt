cmake_minimum_required(VERSION 3.0)

set(PROJ_NAME GBTools)

project(${PROJ_NAME})
set(CMAKE_CXX_STANDARD 11)

file(GLOB SRC
    "src/*.cpp"
    "include/*.h"
)

add_executable(${PROJ_NAME}
    "${SRC}"
)

target_include_directories("${PROJ_NAME}" PRIVATE ${PROJECT_SOURCE_DIR}/./include)