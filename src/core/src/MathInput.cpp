#include "MathInput.hpp"

QJsonObject MathInput::toJson() const {
  return {
      {"name", name},   //
      {"value", value}, //
  };
}
MathInput MathInput::fromJson(const QJsonObject &object) {
  return {
      object["name"].toString(), //
      object["value"].toDouble() //
  };
}
