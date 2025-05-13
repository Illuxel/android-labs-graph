pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import labs.core 1.0

ScrollView {
    id: page

    anchors.fill: parent
    contentWidth: page.width

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

    // Main ui
    Column {
        anchors.fill: parent
        anchors.margins: app.sideMargins
        spacing: 10

        Image {
            id: functionImg
            asynchronous: true
            source: "qrc:/images/function.png"
            fillMode: Image.PreserveAspectFit
            anchors {
                left: parent.left
                right: parent.right
            }
        }

        // Result buttons group
        GroupBox {

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Результат")
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

                TextField {
                    id: resultField
                    readOnly: true
                    placeholderText: qsTr("Результат функції")

                    Layout.fillWidth: true

                    validator: DoubleValidator {
                        notation: DoubleValidator.StandardNotation
                    }
                }

                Button {
                    text: "✅" + qsTr("Розрахувати")
                    ToolTip.text: qsTr("Виводить значення функції в поле ") + resultField.placeholderText
                    ToolTip.visible: hovered

                    Layout.fillWidth: true
                    Layout.preferredWidth: 1

                    onClicked: resultField.text = app.mathFunc.result()
                }
            }
        }

        // List of axes
        GroupBox {

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Змінні осі")
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
                    id: axesList

                    clip: true
                    interactive: true

                    spacing: 12
                    model: app.mathFunc.axes

                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, page.height)

                    // fix android text overlap
                    header: Item {
                        height: 6
                    }
                    // fix

                    delegate: TextField {
                        required property real value
                        required property string name

                        width: axesList.width
                        height: 35

                        placeholderText: qsTr("Введіть значення осі ") + name.toUpperCase() + "(" + value + ")"
                        validator: DoubleValidator {
                            notation: DoubleValidator.StandardNotation
                        }

                        onEditingFinished: app.mathFunc.setValue(name, parseFloat(text))
                    }
                }
            }
        }

        // List of vars
        GroupBox {

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Константи")
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
                    id: varsList

                    clip: true
                    interactive: true

                    spacing: 12
                    model: app.mathFunc.vars

                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, page.height)

                    // fix android text overlap
                    header: Item {
                        height: 6
                    }
                    // fix

                    delegate: TextField {
                        required property real value
                        required property string name

                        width: varsList.width
                        height: 35

                        placeholderText: qsTr("Введіть значення ") + name.toUpperCase() + "(" + value + ")"
                        validator: DoubleValidator {
                            notation: DoubleValidator.StandardNotation
                        }

                        onEditingFinished: app.mathFunc.setValue(name, parseFloat(text))
                    }
                }
            }
        }
    }
}
