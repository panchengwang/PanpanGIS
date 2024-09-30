cmake_minimum_required(VERSION 3.14)

project(symbol LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(JSON_C REQUIRED json-c)

list(APPEND HEADERS 
  Symbol.h
  SymPoint.h
  SymColor.h
  SymStroke.h
  SymShape.h
  SymSystemLine.h
  SymFill.h
  SymCircle.h
  SymArc.h
  SymPie.h 
  SymChord.h
)

list(APPEND SOURCES 
  Symbol.cpp
  SymPoint.cpp
  SymColor.cpp
  SymStroke.cpp
  SymShape.cpp
  SymSystemLine.cpp
  SymFill.cpp
  SymCircle.cpp
  SymArc.cpp
  SymPie.cpp
  SymChord.cpp
)

add_library(symbol SHARED
  ${HEADERS}
  ${SOURCES}
)
target_link_libraries(symbol ${JSON_C_LIBRARIES})
target_include_directories(symbol PUBLIC 
  .. 
  ${JSON_C_INCLUDE_DIRS})
target_compile_options(symbol PUBLIC ${JSON_C_CFLAGS_OTHER})
target_compile_definitions(symbol PRIVATE AS_LIBRARY)


add_subdirectory(test)


install(TARGETS symbol
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES ${HEADERS} 
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/symbol
)



