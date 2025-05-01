#pragma once

#include "MathInput.hpp"
#include "MathResult.hpp"

class MathFunction : public QObject {

  Q_OBJECT
  QML_ELEMENT
  Q_PROPERTY(std::vector<QString> names WRITE setNames CONSTANT);

  Q_PROPERTY(qsizetype currentIndex MEMBER m_CurrentIndex WRITE setVariableIndex
                 NOTIFY currentIndexChanged);

  Q_PROPERTY(qreal step MEMBER m_Step WRITE setStep NOTIFY stepChanged);
  Q_PROPERTY(QPointF range MEMBER m_Range WRITE setRange NOTIFY rangeChanged);

  Q_PROPERTY(MathInputs vars MEMBER m_Vars NOTIFY varsChanged);
  Q_PROPERTY(MathResults results MEMBER m_Results NOTIFY resultsChanged);

public:
  using QObject::QObject;
  using MathInputs = std::vector<MathInput>;
  using MathResults = std::vector<MathResult>;

  void setNames(const std::vector<QString> &names);

  Q_INVOKABLE void setStep(const qreal step);
  Q_INVOKABLE void setRange(const QPointF &range);

  Q_INVOKABLE void setVariableIndex(const qsizetype index);

  void setValue(const qsizetype index, const qreal newValue);
  Q_INVOKABLE void setValue(const QString &name, const qreal newValue);

  inline qreal value(const qsizetype index) const;

  Q_INVOKABLE qreal value(const QString &name) const;
  Q_INVOKABLE QString name(const qsizetype index) const;

  inline qsizetype currentIndex() const { return m_CurrentIndex; }

  inline qreal step() const { return m_Step; }
  inline QPointF range() const { return m_Range; }

  inline MathInputs vars() const { return m_Vars; }
  inline MathResults results() const { return m_Results; }

  std::vector<qreal> points() const;

  Q_INVOKABLE qreal calculate();
  Q_INVOKABLE qint64 calculateRange(const bool start, const bool end);

  void toJson(QJsonObject &object) const;
  void fromJson(const QJsonObject &object);

private:
  qsizetype index(const QStringView name) const;

  void reserve(const qsizetype count);
  void reserveResult(const qsizetype count);

signals:
  void currentIndexChanged();

  void stepChanged();
  void rangeChanged();

  void varsChanged();
  void resultsChanged();

private:
  qsizetype m_CurrentIndex = -1;

  qreal m_Step;
  QPointF m_Range;

  QElapsedTimer m_Timer;

  MathInputs m_Vars;
  MathResults m_Results;
};
