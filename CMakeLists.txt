cmake_minimum_required(VERSION 3.16)
project(wlcterm LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml)

qt_add_executable(wlcterm
    main.cpp
)

set_target_properties(wlcterm PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

target_link_libraries(wlcterm PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Qml
)

set(wlcterm_resource_files
    "main.qml"
)

qt6_add_resources(wlcterm "wlcterm"
    PREFIX
        "/"
    FILES
        ${wlcterm_resource_files}
)
