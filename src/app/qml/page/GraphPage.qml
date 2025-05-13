pragma ComponentBehavior: Bound
import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import labs.core 1.0

ScrollView {
    id: page

    anchors.fill: parent
    contentWidth: page.width

    property Settings settings: Settings {

        property alias currentAxisIndex: axesCombo.currentIndex
        property alias currentGraphIndex: graphsCombo.currentIndex

        property alias rangeStartInclude: rangeStartInclude.checked
        property alias rangeEndInclude: rangeEndInclude.checked

        // Shows a result list from function range
        property alias showResultList: showResultListCheck.checked
    }

    property ListModel graphsList: ListModel {
        ListElement {
            graphName: qsTr("Лінії")
            graphSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/graph/LinesGraph.qml"
        }
        ListElement {
            graphName: qsTr("Точки")
            graphSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/graph/ScatterGraph.qml"
        }
        ListElement {
            graphName: qsTr("Точки 3D")
            graphSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/graph/Scatter3DGraph.qml"
        }
        ListElement {
            graphName: qsTr("Поверхня 3D")
            graphSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/graph/Surface3DGraph.qml"
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

        // Range settings
        GroupBox {

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Проміжок")
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
                        model: app.mathGraph.ranges

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
                                id: rangeMinField
                                placeholderText: qsTr("Мін ") + axis.toUpperCase() + " (" + min + ")"
                                validator: DoubleValidator {
                                    notation: DoubleValidator.StandardNotation
                                }
                                Layout.fillWidth: true
                                onTextEdited: app.mathGraph.setRange(axis, Qt.point(text, max))
                            }

                            TextField {
                                id: rangeMaxField
                                placeholderText: qsTr("Макс ") + axis.toUpperCase() + " (" + max + ")"
                                validator: DoubleValidator {
                                    notation: DoubleValidator.StandardNotation
                                }
                                Layout.fillWidth: true
                                onTextEdited: app.mathGraph.setRange(axis, Qt.point(min, text))
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
                        placeholderText: qsTr("Інтервал") + " (" + app.mathGraph.step + ")"
                        validator: DoubleValidator {
                            notation: DoubleValidator.StandardNotation
                        }
                        Layout.fillWidth: true
                        onTextEdited: app.mathGraph.setStep(text)
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
                            if (axesCombo.currentIndex != -1) {
                                app.mathGraph.place(axesCombo.currentIndex, rangeStartInclude.checked, rangeEndInclude.checked); // const elapsedTime =

                                if (app.settings.value("autoSaveGraph")) {
                                    app.saveManager.save("graph");
                                }
                                if (showResultListCheck.checked) {
                                    pageScroll.setPosition(1.0 - pageScroll.size);
                                }
                                // if (app.settings.value("showElapsedTime")) {
                                //     app.openInfoDialog(qsTr("Обчислювання зайняло: " + elapsedTime + "ms"));
                                // }
                            } else {
                                app.openErrorDialog(qsTr("Ви не обрали вісь"));
                            }
                        }
                    }

                    Button {
                        text: "📈" + qsTr("Розрахувати 3D")

                        Layout.fillWidth: true
                        Layout.preferredWidth: 1

                        onClicked: {
                            app.mathGraph.placeSurface(rangeStartInclude.checked, rangeEndInclude.checked); // const elapsedTime =

                            if (app.settings.value("autoSaveGraph")) {
                                app.saveManager.save("graph");
                            }
                            if (showResultListCheck.checked) {
                                pageScroll.setPosition(1.0 - pageScroll.size);
                            }
                            // if (app.settings.value("showElapsedTime")) {
                            //     app.openInfoDialog(qsTr("Обчислювання зайняло: " + elapsedTime + "ms"));
                            // }
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
                    model: page.graphsList
                    textRole: "graphName"
                    valueRole: "graphSource"
                    Layout.fillWidth: true
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

        // List of function result
        GroupBox {

            visible: showResultListCheck.checked && app.mathGraph.points.length != 0

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
                    model: app.mathGraph.points

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
                        placeholderText: "y: " + pointY + " [x:" + pointX + " z:" + pointZ + "]"

                        width: resultList.width
                        height: 35
                    }
                }
            }
        }
    }
}
