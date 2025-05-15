
set( ASSETS
    images/function.png
    images/profile.png
)

set( THEME_CONFIGS
    config/qtquickcontrols2.conf
    config/+android/qtquickcontrols2.conf
    config/+windows/qtquickcontrols2.conf
)

set( QML_SOURCES

    qml/MainWindow.qml
    qml/page/ProfilePage.qml
    qml/page/SettingsPage.qml
    qml/page/FunctionPage.qml
    qml/page/GraphPage.qml
    qml/graph/LinesGraph.qml
    qml/graph/ScatterGraph.qml
    qml/graph/Scatter3DGraph.qml
    qml/graph/Surface3DGraph.qml
)

set( INCLUDES
)

set( SOURCES
    ${INCLUDES}

    src/main.cpp
)

qt_policy( SET QTP0001 NEW ) # Ensures that modules are put into the QML Import Path and can be found without further setup.
qt_policy( SET QTP0002 NEW ) # Support for cmake generator expressions in android json builds
qt_policy( SET QTP0004 NEW ) #

set( APP_NAME "labs.graph" )

qt_add_executable( ${APP_NAME} ${SOURCES} MANUAL_FINALIZATION )

target_compile_definitions( ${APP_NAME} PUBLIC APP_NAME="${APP_NAME}" )

target_include_directories( ${APP_NAME}
    PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
)
target_link_libraries( ${APP_NAME} PUBLIC Qt6::Qml Qt6::Quick Qt6::QuickControls2 Qt6::Graphs labs.core labs.coreplugin )

set_target_properties( ${APP_NAME} PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
    QT_ANDROID_APP_NAME "${APP_NAME}"
    QT_ANDROID_VERSION_CODE "${PROJECT_VERSION_MAJOR}"
    QT_ANDROID_VERSION_NAME "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}"
    QT_ANDROID_PACKAGE_NAME "${PROJECT_URI}.${APP_NAME}"
    QT_ANDROID_PACKAGE_SOURCE_DIR "${PROJECT_SOURCE_DIR}/src/android"
)

# Register qtquickcontrols2.conf
qt_add_resources( ${APP_NAME} "app_configs"
    BASE "config"
    FILES ${THEME_CONFIGS}
)

# Add images
qt_add_resources( ${APP_NAME} "app_images"
    FILES ${ASSETS}
)

# Add qmls
qt_add_qml_module( ${APP_NAME}
    URI "${APP_NAME}"
    VERSION 1.0
    RESOURCE_PREFIX "${PROJECT_URI}/imports"
    IMPORTS "labs.core/auto"
    QML_FILES ${QML_SOURCES}
)

qt_import_qml_plugins( ${APP_NAME} )

qt_finalize_target( ${APP_NAME} )

install( TARGETS ${APP_NAME}
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET ${APP_NAME}
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install( SCRIPT ${deploy_script} )
