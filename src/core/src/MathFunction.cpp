#include "MathFunction.hpp"
#include "MathInput.hpp"

void MathFunction::setInputs(const QList<MathInput> &mathInputs) {
  m_Inputs = mathInputs;
  setModel(mathInputs);
}

void MathFunction::setModel(const QList<MathInput> &mathInputs) {
  QVariantList varList;
  varList.reserve(mathInputs.size());
  for (const MathInput &input : mathInputs)
    varList.emplace_back(QVariant::fromValue(input));

  m_Model = varList;
  emit modelChanged();
}

void MathFunction::setValue(const qsizetype index, const qreal value) {
  m_Inputs[index].value = value;
  emit inputChanged(index);
}

void MathFunction::setValue(const QString &name, const qreal newValue) {

  const qsizetype index = getIndex(name);

  if (index != -1) {
    m_Inputs[index].value = newValue;
    emit inputChanged(index);
  }
}

qreal MathFunction::value(const QString &name) const {
  const qsizetype index = getIndex(name);

  return index != -1 ? m_Inputs[index].value : qreal();
}

qsizetype MathFunction::getIndex(const QString &name) const {

  for (qsizetype i = 0; i < m_Inputs.size(); ++i)
    if (m_Inputs[i].name == name)
      return i;

  return -1;
}

qreal MathFunction::calculate() {

  const qreal x = value("x");
  const qreal y = value("y");
  const qreal a = value("a");

  return (std::sin(std::pow(x, 3) + 6) - std::sin(y - a)) /
             std::log(std::pow(x, 4)) -
         2 * std::pow(std::sin(x), 5);
}
