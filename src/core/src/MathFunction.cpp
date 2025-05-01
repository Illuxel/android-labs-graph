#include "MathFunction.hpp"

void MathFunction::setNames(const std::vector<QString> &names) {

  reserve(names.size());

  for (const QStringView input : names) {
    m_Vars.emplace_back(input, 0.);
  }
}

void MathFunction::setVariableIndex(const qsizetype i) {
  m_CurrentIndex = i;
  emit currentIndexChanged();
}

void MathFunction::setStep(const qreal step) {
  m_Step = step;
  emit stepChanged();
}
void MathFunction::setRange(const QPointF &range) {
  m_Range = range;
  emit rangeChanged();
}

void MathFunction::reserve(const qsizetype count) {
  m_Vars.clear();
  m_Vars.reserve(count);
}
void MathFunction::reserveResult(const qsizetype count) {
  m_Results.clear();
  m_Results.reserve(count);
}

void MathFunction::setValue(const qsizetype i, const qreal newValue) {
  m_Vars[i].value = newValue;
}
void MathFunction::setValue(const QString &name, const qreal newValue) {

  const qsizetype i = index(name);

  if (Q_LIKELY(i != -1)) {
    setValue(i, newValue);
  }
}

QString MathFunction::name(const qsizetype i) const { return m_Vars[i].name; }

qreal MathFunction::value(const qsizetype i) const { return m_Vars[i].value; }
qreal MathFunction::value(const QString &name) const {
  const qsizetype i = index(name);
  return (Q_LIKELY(i != -1)) ? value(i) : qreal();
}

qsizetype MathFunction::index(const QStringView name) const {
  const auto &it = std::find(m_Vars.cbegin(), m_Vars.cend(), name);
  return it != m_Vars.cend() ? std::distance(m_Vars.cbegin(), it) : -1;
}

void MathFunction::toJson(QJsonObject &object) const {

  object["step"] = m_Step;
  object["variable"] = m_CurrentIndex;
  object["range"] = QJsonArray{m_Range.x(), m_Range.y()};

  QJsonArray vars;
  QJsonArray results;

  QJsonObject varObj;
  QJsonObject resultObj;

  for (const MathInput &var : m_Vars) {
    var.toJson(varObj);
    vars.push_back(varObj);
  }

  for (const MathResult &result : m_Results) {
    result.toJson(resultObj);
    results.push_back(resultObj);
  }

  object["vars"] = std::move(vars);
  object["results"] = std::move(results);
}

void MathFunction::fromJson(const QJsonObject &object) {

  m_Timer.start();

  m_Step = object["step"].toDouble(0.5);
  m_CurrentIndex = object["variable"].toInteger(-1);

  {
    const QJsonArray &range = object["range"].toArray({0., 1.});
    m_Range.setX(range[0].toDouble());
    m_Range.setY(range[1].toDouble());
  }

  const QJsonArray &inputs = object["inputs"].toArray();
  const QJsonArray &results = object["results"].toArray();

  // prepare mem for vars and graph
  reserve(inputs.size());
  reserveResult(results.size());

  {
    MathInput var;

    for (QJsonValueConstRef value : inputs) {
      var.fromJson(value.toObject());
      m_Vars.emplace_back(std::move(var));
    }
  }

  {
    MathResult result;

    for (QJsonValueConstRef value : results) {
      result.fromJson(value.toObject());
      m_Results.emplace_back(std::move(result));
    }
  }

  const qint64 msTime = m_Timer.elapsed();
  const qint64 nsTime = m_Timer.nsecsElapsed();

  qDebug() << "fromJson took: " << msTime << "ms " << nsTime << "ns";

  emit stepChanged();
  emit rangeChanged();

  emit varsChanged();
  emit resultsChanged();
}

qreal MathFunction::calculate() {

  const qreal x = value(0);
  const qreal y = value(1);
  const qreal a = value(2);

  return (std::sin(std::pow(x, 3) + 6) - std::sin(y - a)) /
             std::log(std::pow(x, 4)) -
         2 * std::pow(std::sin(x), 5);
}

qsizetype getRangeSize(const qreal x, const qreal y, const qreal step) {
  if (std::isnan(x) ||    //
      std::isnan(y) ||    //
      std::isnan(step) || //
      y >= x || step <= 0)
    return 0;
  return static_cast<qsizetype>(std::ceil((y - x) / step)) + 1;
}

qint64 MathFunction::calculateRange(const bool start, const bool end) {

  m_Timer.start();

  {
    const qsizetype rangeSize =
        getRangeSize(m_Range.x(), m_Range.y(), m_Step); // precalc size

    reserveResult(rangeSize);
  }

  const qreal modX = start ? m_Range.x() : m_Range.x() + m_Step;
  const qreal modY = end ? m_Range.y() + m_Step : m_Range.y();

  const qreal oldValue = value(currentIndex()); // save old input value

  for (qreal x = modX; x < modY; x += m_Step) {
    setValue(currentIndex(), x);
    m_Results.emplace_back(x, calculate());
  }

  setValue(currentIndex(), oldValue); // restore old value

  const qint64 msTime = m_Timer.elapsed();
  const qint64 nsTime = m_Timer.nsecsElapsed();

  qDebug() << "Calculation took: " << msTime << "ms " << nsTime << "ns";

  emit resultsChanged();

  return msTime;
}
