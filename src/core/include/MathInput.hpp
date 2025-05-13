#pragma once

#include <QtQmlIntegration>

struct MathInput
{
    Q_GADGET
    QML_STRUCTURED_VALUE
    QML_NAMED_ELEMENT(mathInput)
    Q_PROPERTY(qreal value MEMBER value REQUIRED);
    Q_PROPERTY(QChar name MEMBER name REQUIRED);

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

    inline bool operator==(const qreal other) const { return qFuzzyCompare(value, other); }
    inline bool operator==(const QAnyStringView other) const { return name == other; }
    inline bool operator==(const MathInput &other) const
    {
        return name == other.name && qFuzzyCompare(value, other.value);
    }

    inline bool operator!=(const qreal other) const { return !(*this == other); }
    inline bool operator!=(const QAnyStringView other) const { return !(*this == other); }
    inline bool operator!=(const MathInput &other) const { return !(*this == other); }
};
