cmake_minimum_required( VERSION 3.15 )

set( CMAKE_CXX_STANDARD 17 )
set( CMAKE_CXX_STANDARD_REQUIRED ON )

project( labs
    VERSION 4.0
    LANGUAGES CXX
    DESCRIPTION "Android Qt labs"
)

set( PROJECT_URI "nubip.edu.ua" )

find_package( Qt6 COMPONENTS Qml Quick QuickControls2 Graphs REQUIRED )
qt_standard_project_setup( REQUIRES 6.5 I18N_SOURCE_LANGUAGE en )

add_subdirectory( src/core )
add_subdirectory( src/app )
