# Minimal version for CMake
cmake_minimum_required(VERSION 2.8)

# Project's name
project(main)

# Set the usefull path
set(ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# Set the output folder where your program will be created
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${ROOT_PATH}/build/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${ROOT_PATH}/build/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${ROOT_PATH}/build/bin)

# Set default compilation flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -rdynamic -std=c++11")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pthread")

# Include directory
include_directories(${ROOT_PATH})

# Add dependencies
add_subdirectory(IrStd)

# Add main executable
add_executable(main main.cpp)
target_link_libraries(main irstd)
