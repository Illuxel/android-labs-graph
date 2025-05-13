#include "MathFunction.hpp"

void MathFunction::setInputNames(const std::vector<QString> &names)
{
    constexpr std::array<QChar, 3> axes = {'x', 'y', 'z'};

    m_AxesSize = std::count_if(
        names.cbegin(),
        names.cend(), //
        [&axes](const QAnyStringView view) {
            return std::find(axes.cbegin(), axes.cend(), view) != axes.cend();
        });

    reserve(names.size());

    for (const QStringView name : names) {
        m_Inputs.emplace_back(0., name[0]);
    }

    emit inputsChanged();
}

void MathFunction::setValue(const qsizetype i, const qreal newValue)
{
    m_Inputs[i].value = newValue;
}
void MathFunction::setValue(const QString &name, const qreal newValue)
{
    const qsizetype i = index(name);

    if (Q_LIKELY(i != -1)) {
        setValue(i, newValue);
        emit inputsChanged();
    }
}

qreal MathFunction::value(const QString &name) const
{
    const qsizetype i = index(name);
    return (Q_LIKELY(i != -1)) ? value(i) : qreal();
}
QString MathFunction::name(const qsizetype i) const
{
    return m_Inputs[i].name;
}

qsizetype MathFunction::index(const QAnyStringView name) const
{
    const auto &it = std::find(m_Inputs.cbegin(), m_Inputs.cend(), name);
    return (Q_LIKELY(it != m_Inputs.cend())) ? std::distance(m_Inputs.cbegin(), it) : -1;
}
qsizetype MathFunction::axisIndex(const QAnyStringView name) const
{
    const auto &axesOnly = axes();
    const auto &it = std::find(axesOnly.cbegin(), axesOnly.cend(), name);
    return (Q_LIKELY(it != axesOnly.cend())) ? std::distance(axesOnly.cbegin(), it) : -1;
}
qsizetype MathFunction::varIndex(const QAnyStringView name) const
{
    const auto &varsOnly = vars();
    const auto &it = std::find(varsOnly.cbegin(), varsOnly.cend(), name);
    return (Q_LIKELY(it != varsOnly.cend())) ? std::distance(varsOnly.cbegin(), it) : -1;
}

void MathFunction::reserve(const qsizetype count)
{
    m_Inputs.reserve(count);
    m_Inputs.clear();
}

qreal MathFunction::result()
{
    const qreal x = value(0);
    const qreal y = value(1);
    const qreal a = value(2);

    // z= (cos(((x)^3)+6)-sin(y-a))/(ln(x))^4)-2*((sin(x))^5)

    return (std::sin(std::pow(x, 3) + 6) - std::sin(y - a)) / std::log(std::pow(x, 4))
           - 2 * std::pow(std::sin(x), 5);
}

void MathFunction::clear()
{
    for (MathInput &input : m_Inputs) {
        input.value = 0.;
    }

    emit inputsChanged();
}

void MathFunction::toJson(QJsonObject &object) const
{
    QJsonArray varsArray;
    QJsonObject varObj;

    for (const MathInput &axis : axes()) {
        axis.toJson(varObj);
        varsArray.push_back(std::move(varObj));
    }

    object["axes"] = std::move(varsArray);

    for (const MathInput &var : vars()) {
        var.toJson(varObj);
        varsArray.push_back(std::move(varObj));
    }

    object["vars"] = std::move(varsArray);
}
void MathFunction::fromJson(const QJsonObject &object)
{
    const QJsonArray &axes = object["axes"].toArray();
    const QJsonArray &vars = object["vars"].toArray();

    // prepare mem for vars
    reserve(axes.size() + vars.size());

    MathInput input;

    for (QJsonValueConstRef value : axes) {
        input.fromJson(value.toObject());
        m_Inputs.emplace_back(std::move(input));
    }

    for (QJsonValueConstRef value : vars) {
        input.fromJson(value.toObject());
        m_Inputs.emplace_back(std::move(input));
    }

    emit inputsChanged();
}
