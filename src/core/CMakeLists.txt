
set( SHADERS

    # shaders/function.vert
    shaders/function.frag
    shaders/function.comp
)

set( INCLUDES

    include/JsonObjectInterface.hpp
    include/MathInput.hpp
    include/MathRange.hpp
    include/MathPoint.hpp
    include/MathFunction.hpp
    include/MathGraph.hpp
    include/SaveManger.hpp
)

set( SOURCES

    ${INCLUDES}

    src/MathInput.cpp
    src/MathRange.cpp
    src/MathPoint.cpp
    src/MathFunction.cpp
    src/MathGraph.cpp
    src/SaveManager.cpp
)

qt_policy( SET QTP0001 NEW ) # Ensures that modules are put into the QML Import Path and can be found without further setup.
qt_policy( SET QTP0004 NEW ) #

set( LIB_NAME "labs.core" )

qt_add_library( ${LIB_NAME} STATIC MANUAL_FINALIZATION )

target_link_libraries( ${LIB_NAME} PRIVATE Qt6::Qml Qt6::Quick )
target_include_directories( ${LIB_NAME}
    PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
)

qt_add_qml_module( ${LIB_NAME}
    URI "${LIB_NAME}"
    VERSION 1.0
    SOURCES ${SOURCES}
    RESOURCES ${SHADERS}
    OUTPUT_DIRECTORY "labs/core"
    PLUGIN_TARGET "${LIB_NAME}plugin"
    RESOURCE_PREFIX "${PROJECT_URI}/imports"
)

qt_finalize_target( ${LIB_NAME} )
