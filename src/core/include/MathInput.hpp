#pragma once

#include <QtQmlIntegration>

struct MathInput
{
    Q_GADGET
    QML_STRUCTURED_VALUE
    QML_NAMED_ELEMENT(mathInput)
    Q_PROPERTY(qreal value MEMBER value REQUIRED)
    Q_PROPERTY(QChar name MEMBER name REQUIRED)

public:
    qreal value;
    QChar name;

    MathInput() {}
    MathInput(const qreal value, const QChar name)
        : value(value)
        , name(name)
    {}

    void toJson(QJsonObject &object) const;
    void fromJson(const QJsonObject &object);

    bool operator==(const MathInput &other) const { return name == other.name; }
    bool operator==(const QAnyStringView other) const { return name == other; }
};
