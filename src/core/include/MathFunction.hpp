#pragma once

#include <QObject>
#include <QtQmlIntegration>

#include "MathInput.hpp"

class MathFunction : public QObject {

  Q_OBJECT
  QML_ELEMENT
  Q_PROPERTY(QVariant model READ model NOTIFY modelChanged);
  Q_PROPERTY(QList<MathInput> inputs READ inputs WRITE setInputs); //

public:
  using QObject::QObject;

  void setInputs(const QList<MathInput> &mathInputs);

  Q_INVOKABLE void setValue(const qsizetype index, const qreal newValue);
  Q_INVOKABLE void setValue(const QString &name, const qreal newValue);

  Q_INVOKABLE qreal value(const QString &name) const;

  inline QVariant model() const { return m_Model; }
  inline QList<MathInput> inputs() const { return m_Inputs; }

  Q_INVOKABLE qreal calculate();

private:
  void setModel(const QList<MathInput> &mathInputs);

  qsizetype getIndex(const QString &name) const;

signals:
  void modelChanged();
  void inputChanged(const qsizetype currentIndex);

private:
  QList<MathInput> m_Inputs;
  QVariantList m_Model;
};
