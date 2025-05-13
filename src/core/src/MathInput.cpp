#include "MathInput.hpp"

void MathInput::toJson(QJsonObject &object) const
{
    object["value"] = value;        //
    object["name"] = QString(name); //
}
void MathInput::fromJson(const QJsonObject &object)
{
    value = object["value"].toDouble();  //
    name = object["name"].toString()[0]; //
}
