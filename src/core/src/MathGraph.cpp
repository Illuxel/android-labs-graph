#include "MathGraph.hpp"
#include "MathFunction.hpp"

MathPointViewModel::MathPointViewModel(std::vector<MathPoint> &points, QObject *parent)
    : Base(parent)
    , m_PointsView(points)
{}

int MathPointViewModel::rowCount(const QModelIndex &parent) const
{
    return m_PointsView.size();
}
QVariant MathPointViewModel::data(const QModelIndex &index, int role) const
{
    const Qt::Axis axis = static_cast<Qt::Axis>(role);
    const qsizetype row = index.row();

    return m_PointsView[row].get(axis);
}

void MathGraph::setFunction(MathFunction *function)
{
    m_Function = function;
    m_Ranges.reserve(m_Function->axesCount());
    m_Ranges.clear();

    for (const MathInput &axis : m_Function->axes()) {
        m_Ranges.emplace_back(-1, 1, axis.name);
    }

    m_PointsModel = new MathPointViewModel(m_Points, this);

    emit rangesChanged();
}

void MathGraph::setRange(const qsizetype i, const QPointF &range)
{
    m_Ranges[i].min = range.x();
    m_Ranges[i].max = range.y();
}
void MathGraph::setRange(const QString &axis, const QPointF &range)
{
    const qsizetype i = rangeIndex(axis);

    if (Q_LIKELY(i != -1)) {
        if (m_Ranges[i] == range)
            return;
        setRange(i, range);
        emit rangesChanged();
    }
}

qsizetype MathGraph::rangeIndex(const QString &axis) const
{
    const auto &it = std::find(m_Ranges.cbegin(), m_Ranges.cend(), axis);
    return (Q_LIKELY(it != m_Ranges.cend())) ? std::distance(m_Ranges.cbegin(), it) : -1;
}

MathRange MathGraph::range(const QString &axis) const
{
    const qsizetype i = rangeIndex(axis);
    return (Q_LIKELY(i != -1)) ? range(i) : MathRange{};
}

qsizetype MathGraph::rangeLength(const qsizetype i)
{
    const auto [start, end, axis] = range(i);

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

    const auto [min, max, axis] = m_Ranges[axisIndex];

    const qreal modMin = includeMin ? min : min + m_Step;
    const qreal modMax = includeMax ? max + m_Step : max;

    const qreal oldAxis = m_Function->value(axisIndex);

    const qsizetype size = rangeLength(axisIndex);

    reserve(size);

    m_PointsModel->beginResetModel();

    for (qreal axisValue = modMin; axisValue < modMax; axisValue += m_Step) {
        m_Function->setValue(axisIndex, axisValue);

        const qreal y = m_Function->result();

        if (!std::isfinite(y) || std::isnan(y))
            continue;

        m_Points.emplace_back(axisValue, y);
    }

    m_PointsModel->endResetModel();

    m_Function->setValue(axisIndex, oldAxis);

    m_LastElapesedTimeMs = m_Timer.elapsed();
    m_LastElapesedTimeNs = m_Timer.nsecsElapsed();

    emit pointsChanged();
}
void MathGraph::placeSurface(const bool includeMin, const bool includeMax)
{
    m_Timer.start();

    const qsizetype axisXIndex = m_Function->axisIndex("x");
    const qsizetype axisYIndex = m_Function->axisIndex("y");

    const auto [minX, maxX, axisX] = range(axisXIndex);
    const auto [minY, maxY, axisY] = range(axisYIndex);

    const qreal modXMin = includeMin ? minX : minX + m_Step;
    const qreal modYMin = includeMin ? minY : minY + m_Step;

    const qreal modXMax = includeMax ? maxX + m_Step : maxX;
    const qreal modYMax = includeMax ? maxY + m_Step : maxY;

    const qreal oldXAxis = m_Function->value(axisXIndex);
    const qreal oldYAxis = m_Function->value(axisYIndex);

    const qsizetype size = rangeLength(axisXIndex) * rangeLength(axisYIndex);

    reserve(size);

    m_PointsModel->beginResetModel();

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

    m_PointsModel->endResetModel();

    m_Function->setValue(axisXIndex, oldXAxis);
    m_Function->setValue(axisYIndex, oldYAxis);

    m_LastElapesedTimeMs = m_Timer.elapsed();
    m_LastElapesedTimeNs = m_Timer.nsecsElapsed();

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

    m_PointsModel->beginResetModel();
    m_Points.clear();
    m_PointsModel->endResetModel();

    m_LastElapesedTimeMs = m_Timer.elapsed();
    m_LastElapesedTimeNs = m_Timer.nsecsElapsed();

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

    reserve(points.size());

    m_PointsModel->beginResetModel();

    MathPoint point;
    for (QJsonValueConstRef value : points) {
        point.fromJson(value.toObject());
        m_Points.emplace_back(std::move(point));
    }

    m_PointsModel->endResetModel();

    m_LastElapesedTimeMs = m_Timer.elapsed();
    m_LastElapesedTimeNs = m_Timer.nsecsElapsed();

    emit rangesChanged();
    emit pointsChanged();
}
