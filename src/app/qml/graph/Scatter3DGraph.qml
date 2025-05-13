import QtQuick
import QtGraphs

import labs.core 1.0

Item {
    Scatter3D {
        anchors.fill: parent

        axisX: Value3DAxis {
            min: app.mathGraph.ranges[0].min
            max: app.mathGraph.ranges[0].max
        }
        axisZ: Value3DAxis {
            min: app.mathGraph.ranges[1].min
            max: app.mathGraph.ranges[1].max
        }

        Scatter3DSeries {
            ItemModelScatterDataProxy {
                itemModel: app.mathGraph.model
                xPosRole: "pointX"
                yPosRole: "pointY"
                zPosRole: "pointZ"
            }
        }
    }
}
