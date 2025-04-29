pragma ComponentBehavior: Bound
import QtCore
import QtQml.Models
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import labs.core 1.0

import "../js/utils.js" as Utils

ScrollView {
    id: page

    anchors.fill: parent
    contentWidth: width // force page width with margins

    property Dialog msgDialog: app.msgDialog
    property FileDialog fileDialog: app.fileDialog

    property SaveManager saveManager: app.saveManager
    property MathFunction mathFunc: app.mathFunc

    property real sideMargins: 8

    property Settings settings: Settings {
        category: "appSettings"

        property alias autoSaveFunction: autoSaveFunctionCheck.checked
        property alias autoLoadFunction: autoLoadFunctionCheck.checked

        property alias showRangeResult: showRangeResultCheck.checked
        property alias showElapsedTime: showElapsedTimeCheck.checked

        property alias rangeStartInclude: rangeStartInclude.checked
        property alias rangeEndInclude: rangeEndInclude.checked
    }

    // Construction
    Component.onCompleted: {
        if (page.settings.autoLoadFunction) {
            if (page.saveManager.load()) {
                console.log("Function restored");
            } else {
                console.log("Failed to restore a function");
            }
        }
    }
    // Destruction
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
        id: layout
        width: parent.width
        spacing: 10
        padding: 10

        Image {
            id: functionImg
            asynchronous: true
            source: "qrc:/images/function.png"
            fillMode: Image.PreserveAspectFit
            anchors {
                left: parent.left
                leftMargin: page.sideMargins
                right: parent.right
                rightMargin: page.sideMargins
            }
        }

        GroupBox {
            id: funcVarsGroup

            leftPadding: page.sideMargins
            rightPadding: page.sideMargins

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Змінні")
                font.pointSize: 14
                font.bold: true
            }

            anchors {
                left: parent.left
                leftMargin: page.sideMargins
                right: parent.right
                rightMargin: page.sideMargins
            }

            ColumnLayout {
                anchors.fill: parent

                ListView {
                    id: inputVarsList

                    clip: true
                    interactive: true

                    spacing: 12
                    model: page.mathFunc.vars

                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, page.height)

                    // fix android text overlap
                    header: Item {
                        height: 6
                    }
                    // fix

                    ScrollBar.vertical: ScrollBar {
                        parent: inputVarsList.parent
                        policy: ScrollBar.AsNeeded
                    }

                    delegate: TextField {
                        required property real value
                        required property string valueName

                        width: inputVarsList.width
                        height: 35

                        placeholderText: qsTr("Введіть значення ") + valueName + "(" + value + ")..."
                        validator: DoubleValidator {
                            notation: DoubleValidator.StandardNotation
                        }

                        onTextChanged: page.mathFunc.setValue(valueName, parseFloat(text))
                    }
                }
            }
        }

        GroupBox {
            id: rangeGroup

            leftPadding: page.sideMargins
            rightPadding: page.sideMargins

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Проміжок")
                font.pointSize: 14
                font.bold: true
            }

            anchors {
                left: parent.left
                leftMargin: page.sideMargins
                right: parent.right
                rightMargin: page.sideMargins
            }

            ColumnLayout {
                id: rangeFieldLayout
                anchors.fill: parent
                spacing: 10

                ComboBox {
                    id: varsCombo
                    currentIndex: page.mathFunc.currentIndex
                    displayText: currentIndex != -1 ? varsCombo.currentText : qsTr("Оберіть змінну...")
                    model: page.mathFunc.vars
                    valueRole: "value"
                    textRole: "valueName"
                    Layout.fillWidth: true
                    onActivated: page.mathFunc.currentIndex = currentIndex
                }

                RowLayout {
                    spacing: 6
                    Layout.fillWidth: true

                    TextField {
                        id: rangeStartField
                        text: page.mathFunc.range.x
                        placeholderText: qsTr("Початок") + " (" + page.mathFunc.range.x + ")"
                        validator: DoubleValidator {
                            notation: DoubleValidator.StandardNotation
                        }
                        Layout.fillWidth: true
                    }

                    TextField {
                        id: rangeEndField
                        text: page.mathFunc.range.y
                        placeholderText: qsTr("Кінець") + " (" + page.mathFunc.range.y + ")"
                        validator: DoubleValidator {
                            notation: DoubleValidator.StandardNotation
                        }
                        Layout.fillWidth: true
                    }
                }

                TextField {
                    id: rangeStepField
                    text: page.mathFunc.step
                    placeholderText: qsTr("Інтервал") + " (" + page.mathFunc.step + ")"
                    validator: DoubleValidator {
                        notation: DoubleValidator.StandardNotation
                    }
                    Layout.fillWidth: true
                }

                CheckBox {
                    id: rangeStartInclude
                    text: qsTr("Включити початок")
                    checked: page.settings.rangeStartInclude
                }
                CheckBox {
                    id: rangeEndInclude
                    text: qsTr("Включити кінець")
                    checked: page.settings.rangeEndInclude
                }
            }
        }

        GroupBox {
            id: resultGroup

            leftPadding: page.sideMargins
            rightPadding: page.sideMargins

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Результати")
                font.pointSize: 14
                font.bold: true
            }

            anchors {
                left: parent.left
                leftMargin: page.sideMargins
                right: parent.right
                rightMargin: page.sideMargins
            }

            ColumnLayout {
                id: resultLayout
                anchors.fill: parent
                spacing: 10

                TextField {
                    id: resultField
                    readOnly: true
                    placeholderText: qsTr("Результат")
                    validator: DoubleValidator {
                        notation: DoubleValidator.StandardNotation
                    }
                    Layout.fillWidth: true
                }

                RowLayout {
                    spacing: 5
                    Layout.fillWidth: true

                    Button {
                        text: "✅" + qsTr("Розрахувати")
                        Layout.fillWidth: true
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Виводить значення функції в поле 'Результат'")

                        onClicked: resultField.text = page.mathFunc.calculate()
                    }

                    Button {
                        text: "📈" + qsTr("Діапазон")
                        Layout.fillWidth: true
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Виводить значення діапазона в список 'Результат проміжку'")

                        onClicked: {
                            const step = parseFloat(rangeStepField.text);

                            const start = parseFloat(rangeStartField.text);
                            const end = parseFloat(rangeEndField.text);

                            page.mathFunc.setStep(step);
                            page.mathFunc.setRange(Qt.point(start, end));
                            page.mathFunc.setVariableIndex(varsCombo.currentIndex);

                            if (page.mathFunc.currentIndex == -1) {
                                Utils.openErrorDialog(msgDialog, qsTr("Ви не обрали змінну для розрахування діапазону"));
                            } else {
                                const elapsedTime = page.mathFunc.calculateRange(rangeStartInclude.checked, rangeEndInclude.checked);

                                if (showRangeResultCheck.checked) {
                                    pageScroll.setPosition(1.0 - pageScroll.size);
                                    rangeResultGroup.forceActiveFocus();
                                }

                                if (autoSaveFunctionCheck.checked) {
                                    fileDialog.fileMode = FileDialog.SaveFile;
                                    fileDialog.open();
                                }

                                if (showElapsedTimeCheck.checked) {
                                    Utils.openInfoDialog(msgDialog, qsTr("Обчислювання зайняло: " + elapsedTime + "ms"));
                                }
                            }
                        }
                    }
                }

                CheckBox {
                    id: showRangeResultCheck
                    text: qsTr("Показати список результатів проміжку")
                    checked: page.settings.showRangeResult
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: showElapsedTimeCheck
                    text: qsTr("Показати витрачений час")
                    checked: page.settings.showElapsedTime
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: autoSaveFunctionCheck
                    text: qsTr("Автоматично зберігати графік")
                    checked: page.settings.autoSaveFunction
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: autoLoadFunctionCheck
                    text: qsTr("Автоматично завантажувати графік")
                    checked: page.settings.autoLoadFunction
                    Layout.fillWidth: true
                }
            }
        }

        GroupBox {
            id: rangeResultGroup

            visible: showRangeResultCheck.checked

            leftPadding: page.sideMargins
            rightPadding: page.sideMargins

            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Результат проміжку " + varsCombo.currentText + " [" + page.mathFunc.range.x + "," + page.mathFunc.range.y + "] " + rangeResultList.count)
                font.pointSize: 14
                font.bold: true
            }

            anchors {
                left: parent.left
                leftMargin: page.sideMargins
                right: parent.right
                rightMargin: page.sideMargins
            }

            ColumnLayout {
                anchors.fill: parent

                ListView {
                    id: rangeResultList
                    clip: true
                    interactive: true

                    spacing: 10
                    model: page.mathFunc.results

                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, page.height * 0.65)

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }

                    delegate: TextField {
                        required property real resultStep
                        required property real result

                        placeholderText: qsTr("Інтервал: ") + resultStep + qsTr(" Значення: ") + result

                        enabled: false
                        readOnly: true

                        width: rangeResultList.width
                        height: 35
                    }
                }
            }
        }
    }
}
