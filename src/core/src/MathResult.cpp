#include "MathResult.hpp"

QJsonObject MathResult::toJson() const {
  return {
      {"step", step},     //
      {"result", result}, //
  };
}
MathResult MathResult::fromJson(const QJsonObject &object) {
  return {
      object["step"].toDouble(),  //
      object["result"].toDouble() //
  };
}
