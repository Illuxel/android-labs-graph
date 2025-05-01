#include "MathResult.hpp"

void MathResult::toJson(QJsonObject &object) const {
  object["step"] = step;     //
  object["result"] = result; //
}
void MathResult::fromJson(const QJsonObject &object) {
  step = object["step"].toDouble();     //
  result = object["result"].toDouble(); //
}
