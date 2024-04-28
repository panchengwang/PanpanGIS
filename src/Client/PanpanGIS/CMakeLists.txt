cmake_minimum_required(VERSION 3.16)
project(PanpanGIS VERSION 0.1 LANGUAGES CXX)

add_subdirectory(control)
add_subdirectory(base)
add_subdirectory(map)

add_dependencies(PanMap PanControl PanBase)
