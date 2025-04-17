cmake_minimum_required( VERSION 3.15 )

set( CMAKE_CXX_STANDARD 17 )
set( CMAKE_CXX_STANDARD_REQUIRED ON )

project( lab VERSION 1.0 LANGUAGES CXX )

find_package( Qt6 COMPONENTS Core Qml Quick QuickControls2 REQUIRED )
qt_standard_project_setup( REQUIRES 6.5 I18N_SOURCE_LANGUAGE en )

add_subdirectory( src/app )
add_subdirectory( src/qml )
