#include "MathInput.hpp"

void MathInput::toJson(QJsonObject &object) const {
  object["name"] = name;   //
  object["value"] = value; //
}
void MathInput::fromJson(const QJsonObject &object) {
  name = object["name"].toString();   //
  value = object["value"].toDouble(); //
}
