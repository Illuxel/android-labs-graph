#include "MathRange.hpp"

void MathRange::toJson(QJsonObject &object) const
{
    object["min"] = min;            //
    object["max"] = max;            //
    object["axis"] = QString(axis); //
}
void MathRange::fromJson(const QJsonObject &object)
{
    min = object["min"].toDouble();      //
    max = object["max"].toDouble();      //
    axis = object["axis"].toString()[0]; //
}
