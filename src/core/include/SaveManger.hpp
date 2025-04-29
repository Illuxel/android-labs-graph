#pragma once

#include <QObject>
#include <QtQmlIntegration>

class MathFunction;

class SaveManager : public QObject {
  Q_OBJECT
  QML_ELEMENT
  Q_PROPERTY(QString fileName MEMBER m_FileName WRITE setFileName)
  Q_PROPERTY(MathFunction *functionObject MEMBER m_Function WRITE setFunction)

public:
  using QObject::QObject;

  void setFunction(MathFunction *function) { m_Function = function; }
  void setFileName(const QString &fileName) { m_FileName = fileName; }

  inline QString fileName() const { return m_FileName; }

  Q_INVOKABLE bool save(const QUrl &filePath);
  Q_INVOKABLE bool load(const QUrl &filePath);

private:
  MathFunction *m_Function;
  QString m_FileName;
  QElapsedTimer m_Timer;
};
