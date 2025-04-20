pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

import lab.core 1.0

ScrollView {
    id: page

    property real sideMargins: 8

    anchors.fill: parent
    contentWidth: page.width // force page width with margins

    MathFunction {
        id: mathFunc
        inputs: [
            {
                inputName: 'x',
                inputValue: 0.
            },
            {
                inputName: 'y',
                inputValue: 0.
            },
            {
                inputName: 'a',
                inputValue: 0.
            },
        ]
    }

    Column {
        id: layout
        width: page.width
        spacing: 10
        padding: 10

        Image {
            id: functionImg
            asynchronous: true
            source: "qrc:/lab/images/function.png"
            fillMode: Image.PreserveAspectFit
            anchors {
                left: parent.left
                leftMargin: page.sideMargins
                right: parent.right
                rightMargin: page.sideMargins
            }
        }

        RowLayout {
            id: resultLayout
            spacing: 5
            anchors {
                left: parent.left
                leftMargin: page.sideMargins
                right: parent.right
                rightMargin: page.sideMargins
            }

            TextField {
                id: resultField
                placeholderText: qsTr("Результат")
                readOnly: true
                focus: true
                validator: DoubleValidator {}
                Layout.fillWidth: true
            }

            Button {
                text: "✅" + qsTr("Розрахувати")
                onClicked: {
                    resultField.text = mathFunc.calculate();
                    resultField.forceActiveFocus();
                }
            }
        }

        GroupBox {
            anchors {
                left: parent.left
                leftMargin: page.sideMargins
                right: parent.right
                rightMargin: page.sideMargins
            }

            leftPadding: page.sideMargins
            rightPadding: page.sideMargins

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Змінні")
                font.pointSize: 14
            }

            ColumnLayout {
                anchors.fill: parent

                ListView {
                    id: inputList

                    spacing: 10
                    clip: true
                    interactive: true

                    model: mathFunc.model

                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, page.height - functionImg.implicitHeight - resultLayout.implicitHeight - layout.spacing * 2)

                    // fix android text overlap
                    header: Item {
                        height: 6
                    }
                    // fix

                    delegate: TextField {
                        id: varInput

                        required property string inputName
                        required property real inputValue

                        width: parent.width
                        height: 35

                        placeholderText: qsTr("Введіть значення ") + inputName + "..."
                        validator: DoubleValidator {}

                        onTextChanged: mathFunc.setValue(inputName, varInput.text)
                    }

                    ScrollBar.vertical: ScrollBar {
                        id: inputListScroll
                        policy: ScrollBar.AsNeeded
                    }
                }
            }
        }
    }
}
