#include "SaveManger.hpp"

#include "JsonObjectInterface.hpp"

IJsonObjectInterface *SaveManager::interface(const QAnyStringView objectName) const
{
    const auto &it = std::find_if(
        m_JsonObjects.cbegin(), m_JsonObjects.cend(), [objectName](IJsonObjectInterface *object) {
            return object->objectName() == objectName;
        });

    return it != m_JsonObjects.cend() ? *it : Q_NULLPTR;
}

bool SaveManager::save(const QString &objectName)
{
    QFile file(m_FolderPath.toLocalFile() + QDir::separator() + objectName + ".json");
    file.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);

    if (!file.isOpen()) {
        qWarning() << file.errorString();
        return false;
    }

    m_Timer.start();

    QJsonObject object;

    if (IJsonObjectInterface *jsonInterface = interface(objectName)) {
        jsonInterface->toJson(object);
    } else {
        qWarning() << "Object " << objectName << " to save was not found";
        return false;
    }

    const QJsonDocument doc(object);
    file.write(doc.toJson(QJsonDocument::JsonFormat::Compact));

    m_LastElapesedTimeMs = m_Timer.elapsed();
    m_LastElapesedTimeNs = m_Timer.nsecsElapsed();

    return true;
}
bool SaveManager::load(const QString &objectName)
{
    QFile file(m_FolderPath.toLocalFile() + QDir::separator() + objectName + ".json");
    file.open(QFile::ReadOnly | QFile::Text | QFile::ExistingOnly);

    if (!file.isOpen()) {
        qWarning() << file.errorString();
        return false;
    }

    m_Timer.start();

    QJsonParseError *error = nullptr;
    const QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), error);

    if (error) {
        qWarning() << error->errorString();
        return false;
    }

    if (IJsonObjectInterface *jsonInterface = interface(objectName)) {
        jsonInterface->fromJson(doc.object());
    } else {
        qWarning() << "Object " << objectName << " to load was not found";
        return false;
    }

    m_LastElapesedTimeMs = m_Timer.elapsed();
    m_LastElapesedTimeNs = m_Timer.nsecsElapsed();

    return true;
}

bool SaveManager::saveAll()
{
    return false;
}

bool SaveManager::loadAll()
{
    return false;
}
