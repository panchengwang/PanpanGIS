cmake_minimum_required(VERSION 3.5)

project(support)
add_subdirectory(symbol)
# add_subdirectory(skia_c)

include(GNUInstallDirs)

install(FILES dllexport.h 
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)



# message(STATUS prefix:${CMAKE_INSTALL_PREFIX})


# cmake -DCMAKE_INSTALL_PREFIX=`pg_config --bindir`/.. -DCMAKE_BUILD_TYPE=Release ..
# cmake --build .
# cmake --build . --target install 