cmake_minimum_required(VERSION 3.16)

project(PanMap VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QML_IMPORT_PATH "${CMAKE_CURRENT_BINARY_DIR}/.. ${CMAKE_CURRENT_BINARY_DIR}" CACHE STRING "")
# set(QML2_IMPORT_PATH "${CMAKE_CURRENT_BINARY_DIR}/.." CACHE STRING "")
message(STATUS ${QML_IMPORT_PATH})
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Qml Gui QuickControls2)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(PanMap
    main.cpp
)

list(APPEND SINGLETON_QML_FILES
    PanApplication.qml
)
set_source_files_properties(${SINGLETON_QML_FILES}
    PROPERTIES
    QT_QML_SINGLETON_TYPE true
)

qt_add_qml_module(PanMap
    URI cn.pc.gis.map
    VERSION 1.0
    RESOURCE_PREFIX "/"
    QML_FILES
        Main.qml
        PanAccountCreatePanel.qml
        PanPanel.qml
        PanHeader.qml
        PanDesktop.qml
        PanVerifyCode.qml
        PanWindow.qml
        PanBorder.qml
        PanLoginWindow.qml
        PanUserWindow.qml
        PanLogWindow.qml
        PanStandardButtons.qml
        PanFormWindow.qml
        PanConnector.qml
        PanProgress.qml
        ${SINGLETON_QML_FILES}

    SOURCES
        PanAjax.h
        PanAjax.cpp

    RESOURCES
        images/wallpaper.webp
        QML_FILES PanBusyIndicator.qml
        QML_FILES PanNotify.qml

)
# qt_import_qml_plugins(PanMap
#     INCLUDE
#         cn.gis.pcwang.control
# )
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(PanMap PROPERTIES
    # MACOSX_BUNDLE_GUI_IDENTIFIER com.example.PanMap
    MACOSX_BUNDLE_GUI_IDENTIFIER cn.pc.gis.map.PanMap
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS PanMap
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

message(STATUS ${CMAKE_CURRENT_SOURCE_DIR})

if(EMSCRIPTEN)
    target_link_libraries(PanMap
        PRIVATE Qt6::Quick Qt6::Gui Qt6::QuickControls2 Qt6::Qml PanControlplugin
    )
# add_custom_command(
#     TARGET PanMap
#     POST_BUILD
#         # COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.html
#         COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/html/index.html ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.html
# )
elseif(WIN32)
    target_link_libraries(PanMap
        PRIVATE Qt6::Quick Qt6::Gui Qt6::QuickControls2 Qt6::Qml PanControlplugin
    )
add_custom_command(
    TARGET PanMap
    POST_BUILD
    # COMMAND echo "panmap 可执行文件编译完成"
    # COMMAND rm -rf ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.app/Contents/MacOS/cn
    # COMMAND cp -rf ${CMAKE_CURRENT_BINARY_DIR}/../cn ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.app/Contents/MacOS/cn
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_BINARY_DIR}/../cn ${CMAKE_CURRENT_BINARY_DIR}/cn
    # COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_BINARY_DIR}/../cn ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.app/Contents/PlugIns/cn
    # COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_BINARY_DIR}/cn ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.app/Contents/MacOS/cn
)
elseif(APPLE)
    target_link_libraries(PanMap
        PRIVATE Qt6::Quick Qt6::Gui Qt6::QuickControls2 Qt6::Qml
    )
add_custom_command(
    TARGET PanMap
    POST_BUILD
    # COMMAND echo "panmap 可执行文件编译完成"
    # COMMAND rm -rf ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.app/Contents/MacOS/cn
    # COMMAND cp -rf ${CMAKE_CURRENT_BINARY_DIR}/../cn ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.app/Contents/MacOS/cn
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_BINARY_DIR}/../cn ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.app/Contents/MacOS/cn
    # COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_BINARY_DIR}/../cn ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.app/Contents/PlugIns/cn
    # COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_BINARY_DIR}/cn ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.app/Contents/MacOS/cn
)
endif()



