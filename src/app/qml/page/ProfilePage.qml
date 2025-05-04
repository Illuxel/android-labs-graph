import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

ScrollView {
    id: page

    anchors.fill: parent
    contentWidth: page.width

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

    ColumnLayout {
        id: layout
        spacing: 10
        anchors.fill: parent

        Image {
            asynchronous: true
            source: "qrc:/images/profile.png"
            fillMode: Image.PreserveAspectFit
            Layout.topMargin: 10
            Layout.alignment: Qt.AlignCenter
        }

        Label {
            text: qsTr("<h3><b>Самарін Ілля Валерійович</b></h3><br>КН-23004ск | 4 курс")
            font.pointSize: 18
            wrapMode: Text.WordWrap

            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("<p><b>Хочу оновити свої додатки Qt та написати гру на Vulkan.</b></p>")
            font.pointSize: 18
            wrapMode: Text.WordWrap

            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }
    }
}
