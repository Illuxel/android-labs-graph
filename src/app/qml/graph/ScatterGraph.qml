import QtQuick
import QtGraphs

import labs.core 1.0

Item {
    id: graphItem
    anchors.fill: parent

    Component.onCompleted: graphItem.updateGraph()

    function updateGraph() {
        series.clear();
        for (const p of app.mathGraph.points) {
            series.append(p.pointX, p.pointY);
        }
    }

    Connections {
        target: app.mathGraph

        function onPointsChanged() {
            graphItem.updateGraph();
        }
    }

    GraphsView {
        anchors.fill: parent
        axisX: ValueAxis {
            min: app.mathGraph.ranges[0].min
            max: app.mathGraph.ranges[0].max
        }
        axisY: ValueAxis {
            min: app.mathGraph.ranges[1].min
            max: app.mathGraph.ranges[1].max
        }

        ScatterSeries {
            id: series
        }
    }
}
