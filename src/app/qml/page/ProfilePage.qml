import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

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
        anchors.fill: parent
        anchors.margins: app.sideMargins
        spacing: 10

        Image {
            asynchronous: true
            source: "qrc:/images/profile.png"
            fillMode: Image.PreserveAspectFit

            Layout.alignment: Qt.AlignCenter | Qt.AlignTop
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("<h3><b>Самарін Ілля Валерійович</b></h3><br>КН-23004ск | 4 курс")
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pointSize: 18

            Layout.alignment: Qt.AlignCenter | Qt.AlignTop
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("<p><b>Хочу оновити свої додатки Qt та написати гру на Vulkan.</b></p>")
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pointSize: 18

            Layout.alignment: Qt.AlignCenter | Qt.AlignTop
            Layout.fillWidth: true
        }
    }
}
