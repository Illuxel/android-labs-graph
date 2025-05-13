#pragma once

#include <QtQmlIntegration>

struct MathPoint
{
    Q_GADGET
    QML_STRUCTURED_VALUE
    QML_NAMED_ELEMENT(mathPoint)

    Q_PROPERTY(qreal pointX MEMBER x REQUIRED)
    Q_PROPERTY(qreal pointY MEMBER y REQUIRED)
    Q_PROPERTY(qreal pointZ MEMBER z REQUIRED)

public:
    qreal x;
    qreal y;
    qreal z;

    constexpr MathPoint()
        : x{}
        , y{}
        , z{}
    {}
    constexpr MathPoint(const qreal x, const qreal y)
        : x(x)
        , y(y)
        , z{}
    {}
    constexpr MathPoint(const qreal x, const qreal y, const qreal z)
        : x(x)
        , y(y)
        , z(z)
    {}

    template<Qt::Axis Axis>
    constexpr qreal get()
    {
        static_assert(Axis <= Qt::ZAxis, "Unknown axis specified");

        switch (Axis) {
        case Qt::XAxis:
            return x;
        case Qt::YAxis:
            return y;
        case Qt::ZAxis:
            return z;
        }
    }

    constexpr qreal get(const Qt::Axis axis)
    {
        switch (axis) {
        case Qt::XAxis:
            return x;
        case Qt::YAxis:
            return y;
        case Qt::ZAxis:
            return z;
        default:
            return 0.;
        }
    }

    void toJson(QJsonObject &object) const;
    void fromJson(const QJsonObject &object);
};
