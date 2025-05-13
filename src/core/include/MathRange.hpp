#pragma once

#include <QtQmlIntegration>

struct MathRange
{
    Q_GADGET
    QML_STRUCTURED_VALUE
    QML_NAMED_ELEMENT(mathRange)
    Q_PROPERTY(qreal min MEMBER min REQUIRED);
    Q_PROPERTY(qreal max MEMBER max REQUIRED);
    Q_PROPERTY(QChar axis MEMBER axis REQUIRED);

public:
    qreal min;
    qreal max;
    QChar axis;

    MathRange() {}
    MathRange(const qreal min, const qreal max, const QChar axis)
        : min(min)
        , max(max)
        , axis(axis)
    {}

    void toJson(QJsonObject &object) const;
    void fromJson(const QJsonObject &object);

    inline bool operator==(const QAnyStringView other) const { return axis == other; }
    inline bool operator==(const QPointF &other) const { return QPointF{min, max} == other; }
    inline bool operator==(const MathRange &other) const
    {
        return axis == other.axis && qFuzzyCompare(min, other.min) && qFuzzyCompare(max, other.max);
    }

    inline bool operator!=(const QAnyStringView other) const { return !(axis == other); }
    inline bool operator!=(const QPointF &other) const { return !(*this == other); }
    inline bool operator!=(const MathRange &other) const { return !(*this == other); }
};
