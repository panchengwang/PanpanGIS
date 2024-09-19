cmake_minimum_required(VERSION 3.16)

project(PanBase VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_OUTPUT_DIRECTORY  ${CMAKE_BINARY_DIR})

find_package(Qt6 6.5 COMPONENTS Quick REQUIRED)

qt_add_library(PanBase STATIC)

qt_add_qml_module(PanBase
    URI cn.pc.gis.base
    VERSION 1.0
    QML_FILES
    SOURCES
)

set_target_properties(PanBase PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER cn.pc.gis.base
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(PanBase
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(PanBase
    PRIVATE Qt6::Quick)

target_include_directories(PanBase PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

