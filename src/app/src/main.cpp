#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>

#include <QQuickStyle>

qint32 main(int argc, char *argv[]) {

  QGuiApplication app(argc, argv);

  QGuiApplication::setApplicationName("lab1");
  QGuiApplication::setApplicationDisplayName("lab1");
  QGuiApplication::setApplicationVersion("1.0");

  QQuickStyle::setStyle("Material");

  QQmlApplicationEngine engine(":/lab/qml/import/MainWindow.qml");

  if (engine.rootObjects().isEmpty())
    return -1;
  return app.exec();
}
