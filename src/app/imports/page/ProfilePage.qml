import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

ScrollView {
    id: page

    anchors.fill: parent
    contentWidth: page.width

    ColumnLayout {
        id: layout
        spacing: 10
        anchors.fill: parent

        Image {
            id: profileImg
            asynchronous: true
            source: "qrc:/lab/images/profile.png"
            fillMode: Image.PreserveAspectFit
            Layout.topMargin: 10
            Layout.alignment: Qt.AlignCenter
        }

        Label {
            id: text1
            text: qsTr("<h3><b>Самарін Ілля Валерійович</b></h3><br>КН-23004ск | 4 курс")
            font.pointSize: 18
            wrapMode: Text.WordWrap

            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        Label {
            id: text2
            text: qsTr("<p><b>Хочу оновити свої додатки Qt та написати гру на Vulkan</b></p>")
            font.pointSize: 18
            wrapMode: Text.WordWrap

            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }
    }
}
