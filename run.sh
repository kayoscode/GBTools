#!/bin/bash

cd build
cmake ..
cmake --build .
./GBTools
cd ..
