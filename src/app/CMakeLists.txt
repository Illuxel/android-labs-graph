
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

    imports/MainWindow.qml
    imports/page/FunctionPage.qml
    imports/page/ProfilePage.qml
)

qt_policy( SET QTP0004 NEW )
qt_add_executable( lab.app src/main.cpp )

target_link_libraries( lab.app PUBLIC Qt6::Qml Qt6::Quick Qt6::QuickControls2 lab.core lab_coreplugin )

set_target_properties( lab.app PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

qt_import_qml_plugins( lab.app )

# Register qtquickcontrols2.conf
qt_add_resources( lab.app "app_configs"
    PREFIX "/"
    BASE "configs"
    FILES ${THEME_CONFIGS}
)

# Add images
qt_add_resources( lab.app "app_images"
    PREFIX "/lab"
    FILES ${ASSETS}
)

# Add qmls
qt_add_qml_module( lab.app
    URI "lab.app"
    VERSION 1.0
    RESOURCE_PREFIX ""
    IMPORTS "lab.core/auto"
    QML_FILES ${QML_SOURCES}
)

install( TARGETS lab.app
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET lab.app
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install( SCRIPT ${deploy_script} )
