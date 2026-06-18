cmake_minimum_required(VERSION 3.16)

project(pratinjau VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(pratinjau-bin
    main.cpp
)

set(qml_singletons
    qml/Style.qml
    qml/ViewerRegistry.qml
)

set_source_files_properties(${qml_singletons}
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(pratinjau-bin
    URI pratinjau
    QML_FILES qml/Main.qml
    QML_FILES qml/Viewer.qml
    QML_FILES qml/commons/CButton.qml
    QML_FILES qml/commons/CText.qml
    QML_FILES qml/commons/CTextIcon.qml
    QML_FILES qml/commons/SvgIcon.qml
    QML_FILES qml/components/TitleBar.qml
    QML_FILES qml/viewers/ImageViewer.qml
    QML_FILES qml/viewers/NoneViewer.qml
    QML_FILES ${qml_singletons}

    RESOURCES assets/fonts/InputMono-Black.ttf
    RESOURCES assets/fonts/InputMono-Bold.ttf
    RESOURCES assets/fonts/InputMono-ExtraLight.ttf
    RESOURCES assets/fonts/InputMono-Light.ttf
    RESOURCES assets/fonts/InputMono-Medium.ttf
    RESOURCES assets/fonts/InputMono-Regular.ttf
    RESOURCES assets/fonts/InputMono-Thin.ttf
    RESOURCES assets/fonts/PlusJakartaSans.ttf

    RESOURCES assets/icons/image/resolution.svg
    RESOURCES assets/icons/image/pixelated.svg
    RESOURCES assets/icons/image/smooth.svg
    RESOURCES assets/icons/image/image.svg
    RESOURCES assets/icons/image/zoom.svg
    RESOURCES assets/icons/window/close.svg
    RESOURCES assets/icons/window/maximize.svg
    RESOURCES assets/icons/window/minimize.svg
    RESOURCES assets/icons/storage.svg
    RESOURCES assets/icons/folder.svg
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
