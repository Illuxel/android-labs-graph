#pragma once

#include "JsonObjectInterface.hpp"

#include "MathInput.hpp"

class MathFunction : public IJsonObjectInterface
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(std::vector<QString> inputNames WRITE setInputNames);

    Q_PROPERTY(InputsType axes READ axes NOTIFY inputsChanged);
    Q_PROPERTY(InputsType vars READ vars NOTIFY inputsChanged);

public:
    using InputsType = std::vector<MathInput>;

    Q_INVOKABLE void setInputNames(const std::vector<QString> &names);

    /** Sets value of the input by index without emit signal */
    Q_INVOKABLE void setValue(const qsizetype index, const qreal newValue);
    /** Sets value of the input by name emiting signal */
    Q_INVOKABLE void setValue(const QString &name, const qreal newValue);

    inline qsizetype axesCount() const { return m_AxesSize; }

    /** Returns only axes */
    inline InputsType axes() const { return {m_Inputs.cbegin(), m_Inputs.cbegin() + m_AxesSize}; }
    /** Returns only user inputs */
    inline InputsType vars() const { return {m_Inputs.cbegin() + m_AxesSize, m_Inputs.cend()}; }

    /** Returns input value by index */
    inline qreal value(const qsizetype i) const { return m_Inputs[i].value; }
    /** Returns input value by input name*/
    Q_INVOKABLE qreal value(const QString &name) const;

    /** Returns input name by index in array */
    Q_INVOKABLE QString name(const qsizetype i) const;

    qsizetype index(const QAnyStringView name) const;
    Q_INVOKABLE qsizetype axisIndex(const QAnyStringView name) const;
    Q_INVOKABLE qsizetype varIndex(const QAnyStringView name) const;

    /** Calculates a result of a function */
    Q_INVOKABLE qreal result();

    Q_INVOKABLE void clear();

    // Json Interface
    QAnyStringView objectName() const override { return "function"; }
    void toJson(QJsonObject &object) const override;
    void fromJson(const QJsonObject &object) override;
    // Json Interface

private:
    void reserve(const qsizetype count);

signals:
    void inputsChanged();

private:
    qsizetype m_AxesSize;
    InputsType m_Inputs;
};
