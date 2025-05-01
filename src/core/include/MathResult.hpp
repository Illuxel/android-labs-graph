#pragma once

#include <QtQmlIntegration>

struct MathResult {

  Q_GADGET
  QML_STRUCTURED_VALUE
  QML_NAMED_ELEMENT(mathResult)
  Q_PROPERTY(qreal resultStep READ getStep WRITE setStep REQUIRED)
  Q_PROPERTY(qreal result READ getResult WRITE setResult REQUIRED)

public:
  qreal step;
  qreal result;

  MathResult() {}
  MathResult(const qreal step, const qreal result)
      : step(step), result(result) {}

  void setStep(const qreal step) { this->step = step; }
  void setResult(const qreal result) { this->result = result; }

  inline qreal getStep() const { return step; }
  inline qreal getResult() const { return result; }

  void toJson(QJsonObject &object) const;
  void fromJson(const QJsonObject &object);

  bool operator==(const MathResult &other) const {
    return result == other.result && step == other.step;
  }
};
