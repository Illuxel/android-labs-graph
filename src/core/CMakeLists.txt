

set( INCLUDES
    include/MathInput.hpp
    include/MathFunction.hpp
)

set( SOURCES

    ${INCLUDES}

    src/MathInput.cpp
    src/MathFunction.cpp
)

qt_add_library( lab.core STATIC )

target_include_directories( lab.core
    PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
)
target_link_libraries( lab.core PRIVATE Qt6::Qml )

qt_add_qml_module( lab.core
    URI "lab.core"
    VERSION 1.0
    SOURCES ${SOURCES}
    RESOURCE_PREFIX "/"
    OUTPUT_DIRECTORY "lab/core"
    PLUGIN_TARGET "lab_coreplugin"
)
