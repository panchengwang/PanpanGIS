cmake_minimum_required(VERSION 3.14)

project(symbol_c LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

list(APPEND HEADERS 
  symbol_c.h
)

list(APPEND SOURCES 
  symbol_c.cpp
)

add_library(symbol_c SHARED
  ${HEADERS}
  ${SOURCES}
)

target_link_libraries(symbol_c 
  -L../cpp symbol
)
target_compile_definitions(symbol_c PRIVATE AS_LIBRARY)
target_include_directories(symbol_c PUBLIC 
  ../cpp
  ../..
)

include(GNUInstallDirs)

install(TARGETS symbol_c
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES symbol_c.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/symbol_c
)