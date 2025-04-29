#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QQmlExtensionPlugin>

Q_IMPORT_QML_PLUGIN(labs_corePlugin)

qint32 main(int argc, char *argv[]) {

  QGuiApplication app(argc, argv);

  QGuiApplication::setApplicationName("lab3");
  QGuiApplication::setApplicationDisplayName("lab3");
  QGuiApplication::setOrganizationDomain("nubip.edu.ua");

  QQmlApplicationEngine engine;
  engine.addImportPath("qrc:/nubip.edu.ua/imports");
  engine.loadFromModule("labs.app", "MainWindow");

  if (engine.rootObjects().isEmpty())
    return EXIT_FAILURE;
  return app.exec();
}
