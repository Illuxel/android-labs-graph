#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QQmlExtensionPlugin>

Q_IMPORT_QML_PLUGIN(lab_corePlugin)

qint32 main(int argc, char *argv[]) {

  QGuiApplication app(argc, argv);

  QGuiApplication::setApplicationName("lab2");
  QGuiApplication::setApplicationDisplayName("lab2");
  QGuiApplication::setOrganizationDomain("nubip");

  QQmlApplicationEngine engine;

  // engine.addImportPath("qrc:/");

  engine.loadFromModule("lab.app", "MainWindow");

  if (engine.rootObjects().isEmpty())
    return EXIT_FAILURE;
  return app.exec();
}
