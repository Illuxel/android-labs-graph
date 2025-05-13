#pragma once

#include <QJsonObject>

class IJsonObjectInterface : public QObject
{
public:
    using QObject::QObject;

    virtual ~IJsonObjectInterface() override {}

    virtual void toJson(QJsonObject &object) const = 0;
    virtual void fromJson(const QJsonObject &object) = 0;
    virtual inline QAnyStringView objectName() const = 0;
};
