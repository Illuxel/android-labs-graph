pragma ComponentBehavior: Bound
import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import labs.core 1.0

ScrollView {
    id: page

    anchors.fill: parent
    contentWidth: page.width

    property Settings settings: Settings {

        // Selects axis to be changed based on graph
        property alias currentAxisIndex: axesCombo.currentIndex
        //
        property alias currentGraphIndex: graphsCombo.currentIndex

        // Includes or excludes min/max in range
        property alias rangeStartInclude: rangeStartInclude.checked
        property alias rangeEndInclude: rangeEndInclude.checked

        // Shows a result list from function range
        property alias showResultList: showResultListCheck.checked
    }

    property MathGraph graph: app.mathGraph

    property ListModel graphsModel: ListModel {
        ListElement {
            graphName: qsTr("Лінії")
            graphSource: "qrc:/nubip.edu.ua/imports/labs/graph/qml/graph/LinesGraph.qml"
        }
        ListElement {
            graphName: qsTr("Точки")
            graphSource: "qrc:/nubip.edu.ua/imports/labs/graph/qml/graph/ScatterGraph.qml"
        }
        ListElement {
            graphName: qsTr("Точки 3D")
            graphSource: "qrc:/nubip.edu.ua/imports/labs/graph/qml/graph/Scatter3DGraph.qml"
        }
        ListElement {
            graphName: qsTr("Поверхня 3D")
            graphSource: "qrc:/nubip.edu.ua/imports/labs/graph/qml/graph/Surface3DGraph.qml"
        }
    }

    Component.onCompleted: {}
    Component.onDestruction: {}

    ScrollBar.vertical: ScrollBar {
        id: pageScroll
        policy: ScrollBar.AsNeeded
        parent: page.parent
        anchors {
            top: page.top
            bottom: page.bottom
            right: page.right
        }
    }

    // Main Layout
    Column {
        anchors.fill: parent
        anchors.margins: app.sideMargins
        spacing: 10

        // Display Graph
        GroupBox {

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Графік")
                font.pointSize: app.headerTextSize
                font.bold: true
            }

            anchors {
                left: parent.left
                right: parent.right
            }

            ColumnLayout {
                anchors.fill: parent

                // Graph type
                ComboBox {
                    id: graphsCombo
                    displayText: currentIndex != -1 ? graphsCombo.currentText : qsTr("Оберіть тип графіку...")
                    model: page.graphsModel
                    textRole: "graphName"
                    valueRole: "graphSource"
                    Layout.fillWidth: true
                }

                Button {
                    visible: false //graph.model.count > 16000
                    text: qsTr("Показати графік")
                    font.pixelSize: app.headerTextSize
                    font.bold: true
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(page.contentHeight, page.height * 0.50)
                    onClicked: graphLoader.visible = !graphLoader.visible
                }

                // Async graph loader
                Loader {
                    id: graphLoader
                    asynchronous: true
                    source: graphsCombo.currentValue
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(page.contentHeight, page.height * 0.50)
                }
            }
        }

        // Graph settings
        GroupBox {

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Налаштування графіку")
                font.pointSize: app.contentTextSize
                font.bold: true
            }

            anchors {
                left: parent.left
                right: parent.right
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                // Range input axes fields
                RowLayout {
                    spacing: 10

                    Repeater {
                        model: graph.ranges

                        delegate: ColumnLayout {
                            required property real min
                            required property real max
                            required property string axis

                            spacing: 10

                            Label {
                                text: qsTr("Мін/Макс ") + axis.toUpperCase() + ": "
                                horizontalAlignment: Text.AlignHCenter
                                Layout.fillWidth: true
                            }

                            TextField {
                                placeholderText: qsTr("Мін ") + axis.toUpperCase() + " (" + min + ")"
                                validator: DoubleValidator {
                                    notation: DoubleValidator.StandardNotation
                                }
                                Layout.fillWidth: true
                                onEditingFinished: graph.setRange(axis, Qt.point(parseFloat(text), max))
                            }

                            TextField {
                                placeholderText: qsTr("Макс ") + axis.toUpperCase() + " (" + max + ")"
                                validator: DoubleValidator {
                                    notation: DoubleValidator.StandardNotation
                                }
                                Layout.fillWidth: true
                                onEditingFinished: graph.setRange(axis, Qt.point(min, parseFloat(text)))
                            }
                        }
                    }
                }

                // Range step
                ColumnLayout {

                    Label {
                        text: qsTr("Інтервал")
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    TextField {
                        placeholderText: qsTr("Інтервал") + " (" + graph.step + ")"
                        validator: DoubleValidator {
                            notation: DoubleValidator.StandardNotation
                        }
                        Layout.fillWidth: true
                        onTextEdited: graph.step = text
                    }
                }

                ComboBox {
                    id: axesCombo
                    currentIndex: -1//app.mathFunc.currentIndex
                    displayText: currentIndex != -1 ? axesCombo.currentText : qsTr("Оберіть вісь...")
                    model: app.mathFunc.axes
                    textRole: "name"
                    valueRole: "value"
                    Layout.fillWidth: true
                }

                // Result buttons
                RowLayout {

                    Button {
                        text: "📈" + qsTr("Розрахувати 2D")
                        ToolTip.text: qsTr("Виводить значення діапазона в список 'Результат проміжку'")
                        ToolTip.visible: hovered

                        Layout.fillWidth: true
                        Layout.preferredWidth: 1

                        onClicked: {
                            if (axesCombo.currentIndex == -1) {
                                app.openErrorDialog(qsTr("Ви не обрали вісь"));
                            } else {
                                graph.place(axesCombo.currentIndex, rangeStartInclude.checked, rangeEndInclude.checked);

                                if (app.settings.autoSaveGraph) {
                                    app.saveManager.save("graph");
                                }
                                if (showResultListCheck.checked) {
                                    pageScroll.setPosition(1.0 - pageScroll.size);
                                }

                                if (app.settings.showElapsedTime) {
                                    const graphTimeMs = graph.lastElapsedTimeMs();
                                    const graphTimeNs = graph.lastElapsedTimeNs();
                                    const graphText = qsTr("Обчислювання графіку: ") + graphTimeMs + "ms " + graphTimeNs + "ns";

                                    // const saveTimeMs = app.saveManager.lastElapsedTimeMs();
                                    // const saveTimeNs = app.saveManager.lastElapsedTimeNs();
                                    //const saveText = qsTr("Збереження: ") + saveTimeMs + "ms " + saveTimeNs + "ns";

                                    app.showInfoDialog(graphText);
                                }
                            }
                        }
                    }

                    Button {
                        text: "📈" + qsTr("Розрахувати 3D")

                        Layout.fillWidth: true
                        Layout.preferredWidth: 1

                        onClicked: {
                            graph.placeSurface(rangeStartInclude.checked, rangeEndInclude.checked);

                            if (app.settings.autoSaveGraph) {
                                app.saveManager.save("graph");
                            }
                            if (showResultListCheck.checked) {
                                pageScroll.setPosition(1.0 - pageScroll.size);
                            }
                            if (app.settings.showElapsedTime) {
                                const graphTimeMs = graph.lastElapsedTimeMs();
                                const graphTimeNs = graph.lastElapsedTimeNs();

                                const graphText = qsTr("Обчислювання графіку: ") + graphTimeMs + "ms " + graphTimeNs + "ns";

                                // const saveTimeMs = app.saveManager.lastElapsedTimeMs();
                                // const saveTimeNs = app.saveManager.lastElapsedTimeNs();
                                //const saveText = qsTr("Збереження: ") + saveTimeMs + "ms " + saveTimeNs + "ns";

                                app.showInfoDialog(graphText);
                            }
                        }
                    }
                }

                // Extra options
                CheckBox {
                    id: showResultListCheck
                    text: qsTr("Список точок")
                    ToolTip.text: qsTr("Відображає результат з числами проміжку")
                    ToolTip.visible: hovered
                }
                CheckBox {
                    id: rangeStartInclude
                    text: qsTr("Включити початок")
                }
                CheckBox {
                    id: rangeEndInclude
                    text: qsTr("Включити кінець")
                }
            }
        }

        // List of function result
        GroupBox {

            visible: showResultListCheck.checked && graph.points.length != 0

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Список значень ") + "(" + resultList.count + ")"
                font.pointSize: app.contentTextSize
                font.bold: true
            }

            anchors {
                left: parent.left
                right: parent.right
            }

            ColumnLayout {
                anchors.fill: parent

                ListView {
                    id: resultList
                    clip: true
                    interactive: true

                    spacing: 10
                    model: graph.points

                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, page.height * 0.65)

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }

                    delegate: TextField {
                        required property real pointX
                        required property real pointY
                        required property real pointZ

                        readOnly: true
                        text: "y: " + pointY + " [x:" + pointX + " z:" + pointZ + "]"

                        width: resultList.width
                        height: 35
                    }
                }
            }
        }
    }
}
