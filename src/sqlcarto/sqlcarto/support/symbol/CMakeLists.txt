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
  SymSystemFill.h
  SymFill.h
  SymFillSolid.h
  SymCircle.h
  SymEllipse.h
  SymArc.h
  SymPie.h 
  SymChord.h
  SymLineString.h
  SymPolygon.h
  SymShapeWithStroke.h
  SymShapeWithStrokeAndFill.h
  SymRegularPolygon.h 
)

list(APPEND SOURCES 
  Symbol.cpp
  SymPoint.cpp
  SymColor.cpp
  SymStroke.cpp
  SymShape.cpp
  SymSystemLine.cpp
  SymSystemFill.cpp
  SymFill.cpp
  SymFillSolid.cpp
  SymCircle.cpp
  SymEllipse.cpp
  SymArc.cpp
  SymPie.cpp 
  SymChord.cpp
  SymLineString.cpp
  SymPolygon.cpp
  SymShapeWithStroke.cpp
  SymShapeWithStrokeAndFill.cpp
  SymRegularPolygon.cpp 
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

message(STATUS ${JSON_C_LIBRARIES})

add_library(symbol_c SHARED
  symbol_c.h
  symbol_c.cpp
)
target_link_libraries(symbol_c 
  symbol
)
target_compile_definitions(symbol_c PRIVATE AS_LIBRARY)
target_include_directories(symbol PUBLIC 
  .
)
install(TARGETS symbol_c
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
