#pragma once

#include <QtQmlIntegration>

struct MathInput {

  Q_GADGET
  QML_STRUCTURED_VALUE
  QML_NAMED_ELEMENT(mathInput)
  Q_PROPERTY(QString valueName READ getValueName WRITE setValueName REQUIRED)
  Q_PROPERTY(qreal value READ getValue WRITE setValue REQUIRED)

public:
  QString name;
  qreal value;

  MathInput() {}
  MathInput(const QStringView name, const qreal value)
      : name(name), value(value) {}

  void setValueName(const QString &name) { this->name = name; }
  void setValue(const qreal value) { this->value = value; }

  inline QString getValueName() const { return name; }
  inline qreal getValue() const { return value; }

  QJsonObject toJson() const;
  static MathInput fromJson(const QJsonObject &object);

  bool operator==(const QStringView name) const { return this->name == name; }
  bool operator==(const MathInput &other) const {
    return value == other.value && name == other.name;
  }
};
