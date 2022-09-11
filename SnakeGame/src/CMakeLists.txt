

cmake_minimum_required(VERSION 3.23)
project(SnakeGame)


set(SFML_STATIC_LIBRARIES TRUE)

set(CMAKE_PREFIX_PATH "..\\lib\\SFML-2.5.1\\lib\\cmake\\SFML\\")
set(SFML_DIR "..\\lib\\SFML-2.5.1\\lib\\cmake\\SFML\\")

find_package(SFML 2.5.1 COMPONENTS graphics REQUIRED)

add_executable(SnakeGame main.cpp snake.h snake.cpp feed.h feed.cpp)
target_include_directories(SnakeGame PRIVATE "..\\lib\\SFML-2.5.1\\include\\SFML\\")
target_link_libraries(SnakeGame sfml-graphics)
