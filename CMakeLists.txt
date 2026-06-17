cmake_minimum_required(VERSION 3.16)

project(pratinjau VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(pratinjau-bin
    main.cpp
)

qt_add_qml_module(pratinjau-bin
    URI pratinjau
    QML_FILES qml/Main.qml
    QML_FILES qml/commons/CButton.qml
    QML_FILES qml/commons/CText.qml
    QML_FILES qml/commons/CTextIcon.qml
    QML_FILES qml/commons/SvgIcon.qml
    QML_FILES qml/components/TitleBar.qml
    QML_FILES qml/viewer/ImageViewer.qml
    QML_FILES qml/viewer/NoFileViewer.qml

    RESOURCES assets/icons/image/pixelated.svg
    RESOURCES assets/icons/image/smooth.svg
    RESOURCES assets/icons/image/image.svg
    RESOURCES assets/icons/image/zoom.svg
    RESOURCES assets/icons/folder.svg
    RESOURCES assets/icons/window/close.svg
    RESOURCES assets/icons/window/maximize.svg
    RESOURCES assets/icons/window/minimize.svg
    RESOURCES assets/icons/file.svg

    SOURCES src/fileinfo.h src/fileinfo.cpp
)

target_include_directories(pratinjau-bin PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(pratinjau-bin PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER dev.frays.pratinjau
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(pratinjau-bin
    PRIVATE Qt6::Quick Qt6::QuickControls2
)

install(TARGETS pratinjau-bin
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
