import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window

ApplicationWindow {
    id: app
    visible: true

    width: 335
    height: 505

    minimumWidth: 335
    minimumHeight: 505

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("<b>‹<b>")
                font.pointSize: 14
            }
            Label {
                text: "<h3>Самарін Ілля Валерійович</h3>"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                text: qsTr("<b>⋮</b>")
                font.pointSize: 14
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Text {
            id: text1
            text: qsTr("<h3><b>Комп'ютерні Науки</b></h3><br>КН-23004ск | 4 курс")
            font.pointSize: 24
            wrapMode: Text.WordWrap

            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        Text {
            id: text2
            text: qsTr("<p><b>Хочу оновити свої додатки Qt та написати гру на Vulkan</b></p>")
            font.pointSize: 24
            wrapMode: Text.WordWrap

            horizontalAlignment: Text.AlignHCenter

            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
