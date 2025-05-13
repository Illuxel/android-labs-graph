import QtQuick
import QtGraphs

import labs.core 1.0

Item {

    Surface3D {
        anchors.fill: parent

        axisX: Value3DAxis {
            min: app.mathGraph.ranges[0].min
            max: app.mathGraph.ranges[0].max
        }
        axisZ: Value3DAxis {
            min: app.mathGraph.ranges[1].min
            max: app.mathGraph.ranges[1].max
        }

        Surface3DSeries {
            ItemModelSurfaceDataProxy {
                itemModel: app.mathGraph.model
                columnRole: "pointX"
                rowRole: "pointZ"
                yPosRole: "pointY"
            }
        }
    }
}
