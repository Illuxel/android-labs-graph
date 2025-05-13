#include "MathPoint.hpp"

void MathPoint::toJson(QJsonObject &object) const
{
    object["x"] = x; //
    object["y"] = y; //
    object["z"] = z; //
}
void MathPoint::fromJson(const QJsonObject &object)
{
    x = object["x"].toDouble(); //
    y = object["y"].toDouble(); //
    z = object["z"].toDouble(); //
}
