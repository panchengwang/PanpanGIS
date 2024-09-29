cmake_minimum_required(VERSION 3.14)

project(skia_c LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(SKIA REQUIRED skia)

add_library(skia_c SHARED
  sk_capi.h
  sk_capi.cpp
)
target_link_libraries(skia_c ${SKIA_LIBRARIES})
target_include_directories(skia_c PUBLIC ${SKIA_INCLUDE_DIRS})
target_compile_options(skia_c PUBLIC ${SKIA_CFLAGS_OTHER})
target_compile_definitions(skia_c PRIVATE AS_LIBRARY)


add_subdirectory(test)


install(TARGETS skia_c
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES sk_capi.h 
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)




# cmake -DCMAKE_INSTALL_PREFIX=`pg_config --bindir`/.. -DCMAKE_BUILD_TYPE=Release ..
# cmake --build .
# cmake --build . --target install 