cmake_minimum_required(VERSION 3.16)

project(pratinjau VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(pratinjau-bin
    main.cpp
)

qt_add_qml_module(pratinjau-bin
    URI pratinjau
    QML_FILES Main.qml
    QML_FILES viewer/ImageViewer.qml
    QML_FILES viewer/NoFileViewer.qml
    QML_FILES commons/SvgIcon.qml
    QML_FILES components/TitleBar.qml
    RESOURCES assets/icons/close.svg
    RESOURCES assets/icons/maximize.svg
    RESOURCES assets/icons/minimize.svg
    SOURCES fileinfo.h fileinfo.cpp
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
    PRIVATE Qt6::Quick
)

install(TARGETS pratinjau-bin
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
