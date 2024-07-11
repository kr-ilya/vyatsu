cmake_minimum_required(VERSION 3.10)

project(lab6)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)



set(SOURCE_EXE main.cpp)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input.txt ${CMAKE_CURRENT_BINARY_DIR}/Debug/input.txt COPYONLY)

add_executable(main ${SOURCE_EXE})

