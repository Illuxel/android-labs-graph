#include "MathGraph.hpp"
#include "MathFunction.hpp"

MathGraphViewModel::MathGraphViewModel(std::vector<MathPoint> &points, QObject *parent)
    : QAbstractListModel(parent)
    , m_PointsView(points)
{}

void MathGraphViewModel::startModelUpdate()
{
    beginResetModel();
}
void MathGraphViewModel::endModelUpdate()
{
    endResetModel();
}

int MathGraphViewModel::rowCount(const QModelIndex &parent) const
{
    return m_PointsView.size();
}

QVariant MathGraphViewModel::data(const QModelIndex &index, int role) const
{
    if (Q_UNLIKELY(!index.isValid() || index.row() >= m_PointsView.size()))
        return QVariant();

    const Qt::Axis axis = static_cast<Qt::Axis>(role);
    return m_PointsView[index.row()].get(axis);
}

void MathGraph::setFunction(MathFunction *function)
{
    m_Function = function;
    // allocating ranges for dimensions
    m_Ranges.reserve(m_Function->axesCount());
    m_Ranges.clear();

    for (const MathInput &axis : m_Function->axes()) {
        m_Ranges.emplace_back(-1, 1, axis.name);
    }

    if (!m_PointsModel) {
        m_PointsModel = new MathGraphViewModel(m_Points);
    }

    emit rangesChanged();
}

void MathGraph::setStep(const qreal step)
{
    m_Step = step;
    emit stepChanged();
}

void MathGraph::setRange(const qsizetype i, const QPointF &range)
{
    m_Ranges[i].min = range.x();
    m_Ranges[i].max = range.y();
}
void MathGraph::setRange(const QString &axis, const QPointF &range)
{
    const auto &it = std::find(m_Ranges.cbegin(), m_Ranges.cend(), axis);
    const qsizetype i = std::distance(m_Ranges.cbegin(), it);

    setRange(i, range);

    emit rangesChanged();
}

qsizetype MathGraph::rangeLength(const qsizetype i)
{
    const auto [start, end, name] = range(i);

    if (Q_UNLIKELY(
            std::isnan(start) ||  //
            std::isnan(end) ||    //
            std::isnan(step()) || //
            step() <= 0))
        return 0;
    return static_cast<qsizetype>(std::ceil((end - start) / step())) + 1;
}

void MathGraph::reserve(const qsizetype count)
{
    m_Points.reserve(count);
    m_Points.clear();
}

void MathGraph::place(const qsizetype axisIndex, const bool includeMin, const bool includeMax)
{
    m_Timer.start();

    const MathRange &range = m_Ranges[axisIndex];

    const qreal modMin = includeMin ? range.min : range.min + m_Step;
    const qreal modMax = includeMax ? range.max + m_Step : range.max;

    reserve(rangeLength(axisIndex));

    const qreal oldAxis = m_Function->value(axisIndex);

    m_PointsModel->startModelUpdate();

    for (qreal axisValue = modMin; axisValue < modMax; axisValue += m_Step) {
        m_Function->setValue(axisIndex, axisValue);

        const qreal result = m_Function->result();

        if (!std::isfinite(result) || std::isnan(result))
            continue;

        m_Points.emplace_back(axisValue, result);
    }

    m_PointsModel->endModelUpdate();
    m_Function->setValue(axisIndex, oldAxis);

    const qint64 msTime = m_Timer.elapsed();
    const qint64 nsTime = m_Timer.nsecsElapsed();

    qInfo() << "Calculation took: " << msTime << "ms " << nsTime << "ns";

    emit pointsChanged();
}
void MathGraph::placeSurface(const bool includeMin, const bool includeMax)
{
    m_Timer.start();

    const qsizetype axisXIndex = m_Function->axisIndex("x");
    const qsizetype axisYIndex = m_Function->axisIndex("y");

    const MathRange &rangeX = m_Ranges[axisXIndex];
    const MathRange &rangeY = m_Ranges[axisYIndex];

    const qreal modXMin = includeMin ? rangeX.min : rangeX.min + m_Step;
    const qreal modYMin = includeMin ? rangeY.min : rangeY.min + m_Step;

    const qreal modXMax = includeMax ? rangeX.max + m_Step : rangeX.max;
    const qreal modYMax = includeMax ? rangeY.max + m_Step : rangeY.max;

    reserve(rangeLength(axisXIndex) * rangeLength(axisYIndex));

    const qreal oldXAxis = m_Function->value(axisXIndex);
    const qreal oldYAxis = m_Function->value(axisYIndex);

    m_PointsModel->startModelUpdate();

    for (qreal x = modXMin; x < modXMax; x += m_Step) {
        for (qreal z = modYMin; z < modYMax; z += m_Step) {
            m_Function->setValue(axisXIndex, x);
            m_Function->setValue(axisYIndex, z);

            const qreal y = m_Function->result();

            if (!std::isfinite(y) || std::isnan(y))
                continue;

            m_Points.emplace_back(x, y, z);
        }
    }

    m_PointsModel->endModelUpdate();

    m_Function->setValue(axisXIndex, oldXAxis);
    m_Function->setValue(axisYIndex, oldYAxis);

    const qint64 msTime = m_Timer.elapsed();
    const qint64 nsTime = m_Timer.nsecsElapsed();

    qInfo() << "Calculation took: " << msTime << "ms " << nsTime << "ns";

    emit pointsChanged();
}

void MathGraph::placeCompute(const bool includeStart, const bool includeEnd) {}

void MathGraph::clear()
{
    m_Timer.start();

    m_Step = 0.25;

    for (MathRange &range : m_Ranges) {
        range.min = 0.;
        range.max = 10.;
    }

    m_PointsModel->startModelUpdate();
    m_Points.clear();
    m_PointsModel->endModelUpdate();

    const qint64 msTime = m_Timer.elapsed();
    const qint64 nsTime = m_Timer.nsecsElapsed();

    qInfo() << "Clearing took: " << msTime << "ms " << nsTime << "ns";

    emit stepChanged();
    emit rangesChanged();
    emit pointsChanged();
}

void MathGraph::toJson(QJsonObject &object) const
{
    QJsonArray array;
    QJsonObject obj;

    object["step"] = m_Step;

    for (const MathRange &range : m_Ranges) {
        range.toJson(obj);
        array.push_back(std::move(obj));
    }

    object["ranges"] = std::move(array);

    for (const MathPoint &point : m_Points) {
        point.toJson(obj);
        array.push_back(std::move(obj));
    }

    object["points"] = std::move(array);
}
void MathGraph::fromJson(const QJsonObject &object)
{
    m_Timer.start();

    m_Step = object["step"].toDouble(0.5);

    const QJsonArray &ranges = object["ranges"].toArray();
    const QJsonArray &points = object["points"].toArray();

    if (ranges.size() == m_Ranges.size()) {
        for (qsizetype i = 0; i < m_Ranges.size(); ++i) {
            m_Ranges[i].fromJson(ranges[i].toObject());
        }
    } else {
        qWarning() << "Range axes are not the same size";
    }

    // prepare mem for graph points
    reserve(points.size());

    m_PointsModel->startModelUpdate();

    MathPoint point;
    for (QJsonValueConstRef value : points) {
        point.fromJson(value.toObject());
        m_Points.emplace_back(std::move(point));
    }

    m_PointsModel->endModelUpdate();

    const qint64 msTime = m_Timer.elapsed();
    const qint64 nsTime = m_Timer.nsecsElapsed();

    qInfo() << "fromJson took: " << msTime << "ms " << nsTime << "ns";

    emit stepChanged();
    emit rangesChanged();
    emit pointsChanged();
}
