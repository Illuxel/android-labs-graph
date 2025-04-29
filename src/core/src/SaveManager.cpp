#include "SaveManger.hpp"

#include "MathFunction.hpp"

bool SaveManager::save(const QUrl &filePath) {

  QFile file(filePath.toLocalFile());

  if (!m_Function) {
    return false;
  }

  file.open(QFile::WriteOnly | QFile::Text);

  if (!file.isOpen()) {
    qDebug() << file.errorString();
    return false;
  }

  m_Timer.start();

  const QJsonDocument doc(m_Function->toJson());
  file.write(doc.toJson(QJsonDocument::JsonFormat::Compact));
  file.close();

  qDebug() << "Saving file took: " << m_Timer.elapsed() << "ms "
           << m_Timer.nsecsElapsed() << "ns";

  return true;
}
bool SaveManager::load(const QUrl &filePath) {

  QFile file(filePath.toLocalFile());

  if (!m_Function) {
    return false;
  }

  file.open(QFile::ReadOnly | QFile::Text | QFile::ExistingOnly);

  if (!file.isOpen()) {
    qDebug() << file.errorString();
    return false;
  }

  m_Timer.start();

  const QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
  m_Function->fromJson(doc.object());
  file.close();

  qDebug() << "Loading file took: " << m_Timer.elapsed() << "ms "
           << m_Timer.nsecsElapsed() << "ns";

  return true;
}
