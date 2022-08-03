#!/bin/bash

cmake -H. -Bbuild-cmake -GNinja -DCMAKE_TOOLCHAIN_FILE=/opt/devkitpro/cmake/Switch.cmake
cmake --build build-cmake --target soh_nro
