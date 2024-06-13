cmake_minimum_required(VERSION 3.16)



project(PanControl VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_OUTPUT_DIRECTORY  ${CMAKE_BINARY_DIR})

find_package(Qt6 6.5 COMPONENTS Quick QuickControls2 REQUIRED)

if(EMSCRIPTEN)
    qt_add_library(PanControl STATIC)
elseif(WIN32)
    qt_add_library(PanControl STATIC)
else()
    qt_add_library(PanControl SHARED)
endif()



list(APPEND SINGLETON_QML_FILES
    PanStyles.qml
    PanFonts.qml
    PanMaterialIcons.qml
    PanAwesomeIcons.qml
)
set_source_files_properties(${SINGLETON_QML_FILES}
    PROPERTIES
    QT_QML_SINGLETON_TYPE true
)

list(APPEND QML_FILES
    PanButton.qml
    PanLabel.qml
    PanTextField.qml
    PanOkCancelButtons.qml
)

qt_add_qml_module(PanControl
    URI cn.pc.gis.control
    VERSION 1.0
    QML_FILES
        ${SINGLETON_QML_FILES}
        ${QML_FILES}
    RESOURCES
        # fonts/NotoSansSC-Light.ttf
        fonts/NotoSansSC-Regular.ttf
        fonts/font-gis.ttf
        # fonts/Material-Design-Iconic-Font.ttf
        # fonts/MaterialIconsOutlined-Regular.otf
        fonts/fa-regular-400.ttf
        fonts/fa-solid-900.ttf
        fonts/fa-brands-400.ttf
        fonts/MaterialIcons-Regular.ttf
        icons/panpangis.svg
        icons/pcwang_gis2.svg

    SOURCES
        src/MapCanvas.h
        src/MapCanvas.cpp
        src/PanInputManager.h
        src/PanInputManager.cpp


)

set_target_properties(PanControl PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER cn.pc.gis.control
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(PanControl
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(PanControl
    PRIVATE Qt6::Quick Qt6::QuickControls2)

target_include_directories(PanControl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src)


# add_custom_command(
#     TARGET PanControl
#     POST_BUILD
#         COMMAND echo "control库编译完成"
# )
