#pragma once

#include <QObject>
#include <QtQmlIntegration>

class MathFunction;

class SaveManager : public QObject {
  Q_OBJECT
  QML_ELEMENT
  Q_PROPERTY(
      QUrl filePath MEMBER m_FilePath WRITE setFilePath NOTIFY filePathChanged)
  Q_PROPERTY(MathFunction *functionObject MEMBER m_Function WRITE setFunction)

public:
  using QObject::QObject;

  void setFunction(MathFunction *function) { m_Function = function; }
  void setFilePath(const QUrl &fileName) { m_FilePath = fileName; }

  Q_INVOKABLE bool save();
  Q_INVOKABLE bool load();

signals:
  void filePathChanged();

private:
  QUrl m_FilePath;
  QElapsedTimer m_Timer;
  MathFunction *m_Function;
};
