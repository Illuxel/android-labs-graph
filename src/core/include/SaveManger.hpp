#pragma once

#include <QtQmlIntegration>

class IJsonObjectInterface;

class SaveManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QUrl folderPath MEMBER m_FolderPath);
    Q_PROPERTY(ObjectInterfacesType objects MEMBER m_JsonObjects);

public:
    using QObject::QObject;
    using ObjectInterfacesType = std::vector<IJsonObjectInterface *>;

    Q_INVOKABLE bool save(const QString &objectName);
    Q_INVOKABLE bool load(const QString &objectName);

    Q_INVOKABLE bool saveAll();
    Q_INVOKABLE bool loadAll();

    Q_INVOKABLE bool isFolderValid() const { return m_FolderPath.isValid(); }

    Q_INVOKABLE inline quint64 lastElapsedTimeMs() const { return m_LastElapesedTimeMs; }
    Q_INVOKABLE inline quint64 lastElapsedTimeNs() const { return m_LastElapesedTimeNs; }

private:
    IJsonObjectInterface *interface(const QAnyStringView objectName) const;

private:
    QElapsedTimer m_Timer;
    quint64 m_LastElapesedTimeMs, m_LastElapesedTimeNs;

    QUrl m_FolderPath;
    ObjectInterfacesType m_JsonObjects;
};
