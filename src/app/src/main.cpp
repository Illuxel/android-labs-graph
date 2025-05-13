#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QQmlExtensionPlugin>

Q_IMPORT_QML_PLUGIN(labs_corePlugin)

qint32 main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QGuiApplication::setOrganizationDomain("nubip.edu.ua");
    QGuiApplication::setApplicationName("lab4");
    QGuiApplication::setApplicationDisplayName("lab4");

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/nubip.edu.ua/imports");
    engine.loadFromModule("labs.app", "MainWindow");

    if (engine.rootObjects().isEmpty())
        return EXIT_FAILURE;
    return app.exec();
}
