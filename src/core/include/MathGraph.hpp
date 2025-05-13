#pragma once

#include "JsonObjectInterface.hpp"

#include "MathPoint.hpp"
#include "MathRange.hpp"

// TODO: Add function computing shaders if device supports it

class MathFunction;

class MathGraphViewModel : public QAbstractListModel
{
public:
    MathGraphViewModel(std::vector<MathPoint> &points, QObject *parent = Q_NULLPTR);

    void startModelUpdate();
    void endModelUpdate();

    inline QHash<int, QByteArray> roleNames() const override
    {
        return {{Qt::XAxis, "pointX"}, {Qt::YAxis, "pointY"}, {Qt::ZAxis, "pointZ"}};
    }

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role) const override;

private:
    std::vector<MathPoint> &m_PointsView;
};

class MathGraph : public IJsonObjectInterface
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(MathFunction *mathFunc WRITE setFunction);

    Q_PROPERTY(qreal step READ step WRITE setStep NOTIFY stepChanged);
    Q_PROPERTY(RangesType ranges READ ranges NOTIFY rangesChanged);
    Q_PROPERTY(PointsType points READ points NOTIFY pointsChanged);
    Q_PROPERTY(ModelViewType *model READ model NOTIFY pointsChanged);

public:
    using RangesType = std::vector<MathRange>;
    using PointsType = std::vector<MathPoint>;
    using ModelViewType = MathGraphViewModel;

    void setFunction(MathFunction *function);

    Q_INVOKABLE void setStep(const qreal step);

    Q_INVOKABLE void setRange(const qsizetype index, const QPointF &range);
    Q_INVOKABLE void setRange(const QString &axis, const QPointF &range);

    Q_INVOKABLE qsizetype rangeLength(const qsizetype index);

    inline qreal step() const { return m_Step; }
    inline MathRange range(const qsizetype index) const { return m_Ranges[index]; }

    inline RangesType ranges() const { return m_Ranges; }
    inline PointsType points() const { return m_Points; }

    inline ModelViewType *model() const { return m_PointsModel; }

    /** Places function on 2D graph where XY is range */
    Q_INVOKABLE void place(const qsizetype axisIndex, const bool includeStart, const bool includeEnd);

    /** Places function on 3D graph where XZ is range and height Y */
    Q_INVOKABLE void placeSurface(const bool includeStart, const bool includeEnd);

    /** Places function on graph and computes each entry in compute shader */
    Q_INVOKABLE void placeCompute(const bool includeStart, const bool includeEnd);

    /** Clears graph */
    Q_INVOKABLE void clear();

    // Json Interface
    QAnyStringView objectName() const override { return "graph"; }
    void toJson(QJsonObject &object) const override;
    void fromJson(const QJsonObject &object) override;
    // Json Interface

private:
    /** Reserves capacity for point result list */
    void reserve(const qsizetype count);

signals:
    void stepChanged();
    void rangesChanged();
    void pointsChanged();

private:
    QElapsedTimer m_Timer;
    qreal m_Step;

    MathFunction *m_Function;

    RangesType m_Ranges;
    PointsType m_Points;
    ModelViewType *m_PointsModel;
};
