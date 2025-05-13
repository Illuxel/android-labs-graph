pragma ComponentBehavior: Bound
import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ScrollView {
    id: page

    anchors.fill: parent
    contentWidth: page.width

    property Settings settings: Settings {
        // Saves function automatically to a file
        property alias autoSaveFunction: autoSaveFunctionCheck.checked
        // Reads function from a file automatically
        property alias autoLoadFunction: autoLoadFunctionCheck.checked

        // Saves graph automatically to a file
        property alias autoSaveGraph: autoSaveGraphCheck.checked
        // Reads graph from a file automatically
        property alias autoLoadGraph: autoLoadGraphCheck.checked

        // Shows time took to calculate function range
        //property alias showElapsedTime: showElapsedTimeCheck.checked
    }

    Component.onCompleted: {}
    Component.onDestruction: {
        page.settings.sync();
    }

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

    Column {
        anchors.fill: parent
        anchors.margins: app.sideMargins
        spacing: 10

        GroupBox {
            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Файл")
                font.pointSize: app.contentTextSize
                font.bold: true
            }

            anchors {
                left: parent.left
                right: parent.right
            }

            ColumnLayout {
                anchors.fill: parent

                RowLayout {

                    TextField {
                        text: app.folderDialog.currentFolder
                        placeholderText: qsTr("Шлях до файлів")
                        readOnly: true
                        Layout.fillWidth: true
                    }
                    Button {
                        text: qsTr("Змінити")
                        onClicked: app.folderDialog.open()
                    }
                }
            }
        }

        GroupBox {
            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Функція")
                font.pointSize: app.contentTextSize
                font.bold: true
            }

            anchors {
                left: parent.left
                right: parent.right
            }

            ColumnLayout {
                anchors.fill: parent

                CheckBox {
                    id: autoSaveFunctionCheck
                    text: qsTr("Автоматично зберігати функцію")
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: autoLoadFunctionCheck
                    text: qsTr("Автоматично завантажувати функцію")
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    Layout.fillWidth: true
                }
            }
        }

        GroupBox {
            label: Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Графік")
                font.pointSize: app.contentTextSize
                font.bold: true
            }

            anchors {
                left: parent.left
                right: parent.right
            }

            ColumnLayout {
                anchors.fill: parent

                CheckBox {
                    id: autoSaveGraphCheck
                    text: qsTr("Автоматично зберігати графік")
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: autoLoadGraphCheck
                    text: qsTr("Автоматично завантажувати графік")
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    Layout.fillWidth: true
                }
            }
        }
    }
}
