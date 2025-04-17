
set( JAVA_SOURCES
)

set( SOURCES
    ${JAVA_SOURCES}

    src/main.cpp
)

qt_add_executable( lab.app MANUAL_FINALIZATION ${SOURCES} )

set_target_properties( lab.app PROPERTIES
    QT_ANDROID_APP_NAME "labs"
    QT_ANDROID_PACKAGE_NAME "uni.labs.app"
)

qt_finalize_executable( lab.app )

target_include_directories( lab.app PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>" )
target_link_libraries( lab.app PRIVATE Qt6::Qml Qt6::Quick Qt6::QuickControls2 lab.qml )
