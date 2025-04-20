#pragma once

#include <QtQmlIntegration>

struct MathInput {

  Q_GADGET
  QML_ELEMENT
  QML_STRUCTURED_VALUE
  Q_PROPERTY(QString inputName READ getName WRITE setName REQUIRED)
  Q_PROPERTY(qreal inputValue READ getValue WRITE setValue REQUIRED)
  QML_VALUE_TYPE(mathInput)

public:
  QString name;
  qreal value;

  MathInput() {}
  MathInput(const QString name, const qreal value) : name(name), value(value) {}

  void setName(const QString name) { this->name = name; }
  void setValue(const qreal value) { this->value = value; }

  inline QString getName() const { return name; }
  inline qreal getValue() const { return value; }
};
