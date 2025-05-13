pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
                        text: app.settings.currentFolderPath
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
                    text: qsTr("Автоматично зберігати функцію")
                    checked: app.settings.autoSaveFunction
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    Layout.fillWidth: true
                    onCheckedChanged: app.settings.autoSaveFunction = checked
                }
                CheckBox {
                    text: qsTr("Автоматично завантажувати функцію")
                    checked: app.settings.autoLoadFunction
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    Layout.fillWidth: true
                    onCheckedChanged: app.settings.autoLoadFunction = checked
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
                    text: qsTr("Автоматично зберігати графік")
                    checked: app.settings.autoSaveGraph
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    Layout.fillWidth: true
                    onCheckedChanged: app.settings.autoSaveGraph = checked
                }
                CheckBox {
                    text: qsTr("Автоматично завантажувати графік")
                    checked: app.settings.autoLoadGraph
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    Layout.fillWidth: true
                    onCheckedChanged: app.settings.autoLoadGraph = checked
                }
            }
        }
    }
}
