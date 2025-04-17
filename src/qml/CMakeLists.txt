set( QML_SOURCES
    import/MainWindow.qml
)

qt_add_library( lab.qml STATIC )

qt_add_qml_module( lab.qml
    URI "lab.qml"
    RESOURCE_PREFIX "/"
    QML_FILES ${QML_SOURCES}
    NO_PLUGIN
)

target_link_libraries( lab.qml PRIVATE Qt6::Quick Qt6::QuickControls2 )
