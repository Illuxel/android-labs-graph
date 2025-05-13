#pragma once

#include "JsonObjectInterface.hpp"

#include "MathPoint.hpp"
#include "MathRange.hpp"

// TODO: Add function computing shaders if device supports it

class MathFunction;

class MathPointViewModel : public QAbstractListModel
{
public:
    using Base = QAbstractListModel;
    using Base::beginResetModel;
    using Base::endResetModel;

    MathPointViewModel(std::vector<MathPoint> &points, QObject *parent = Q_NULLPTR);

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

    Q_PROPERTY(qreal step MEMBER m_Step NOTIFY stepChanged);

    Q_PROPERTY(RangeListType ranges MEMBER m_Ranges NOTIFY rangesChanged);
    Q_PROPERTY(PointListType points MEMBER m_Points NOTIFY pointsChanged);
    Q_PROPERTY(PointsModelType *model MEMBER m_PointsModel NOTIFY pointsChanged);

public:
    using RangeListType = std::vector<MathRange>;
    using PointListType = std::vector<MathPoint>;
    using PointsModelType = MathPointViewModel;

    void setFunction(MathFunction *function);

    Q_INVOKABLE void setRange(const qsizetype index, const QPointF &range);
    Q_INVOKABLE void setRange(const QString &axis, const QPointF &range);

    Q_INVOKABLE qsizetype rangeIndex(const QString &axis) const;

    Q_INVOKABLE inline MathRange range(const qsizetype index) const { return m_Ranges[index]; }
    Q_INVOKABLE MathRange range(const QString &axis) const;

    Q_INVOKABLE qsizetype rangeLength(const qsizetype index);

    inline qreal step() const { return m_Step; }

    inline RangeListType ranges() const { return m_Ranges; }
    inline PointListType points() const { return m_Points; }

    inline PointsModelType *model() const { return m_PointsModel; }

    /** Places function on 2D graph where XY is range */
    Q_INVOKABLE void place(const qsizetype axisIndex, const bool includeStart, const bool includeEnd);

    /** Places function on 3D graph where XZ is range and height Y */
    Q_INVOKABLE void placeSurface(const bool includeStart, const bool includeEnd);

    /** Places function on graph and computes each entry in compute shader */
    Q_INVOKABLE void placeCompute(const bool includeStart, const bool includeEnd);

    Q_INVOKABLE inline quint64 lastElapsedTimeMs() const { return m_LastElapesedTimeMs; }
    Q_INVOKABLE inline quint64 lastElapsedTimeNs() const { return m_LastElapesedTimeNs; }

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
    quint64 m_LastElapesedTimeMs, m_LastElapesedTimeNs;

    MathFunction *m_Function;

    RangeListType m_Ranges;
    PointListType m_Points;
    PointsModelType *m_PointsModel;
};
