cmake_minimum_required(VERSION 3.5)

project(support)
add_subdirectory(symbol)
add_subdirectory(skia_c)


install(FILES dllexport.h 
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)



# cmake -DCMAKE_INSTALL_PREFIX=`pg_config --bindir`/.. -DCMAKE_BUILD_TYPE=Release ..
# cmake --build .
# cmake --build . --target install 