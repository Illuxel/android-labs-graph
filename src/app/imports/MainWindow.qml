pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    id: app
    visible: true

    // minimumWidth: 250
    // minimumHeight: 325

    menuBar: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("<b>⋮</b>")
                font.pointSize: 14

                onClicked: menu.popup()
            }
            Label {
                id: pageLabel
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                Layout.fillWidth: true
            }
        }

        Menu {
            id: menu

            Repeater {
                model: pagesModel
                delegate: MenuItem {
                    required property string pageName

                    text: pageName
                    onTriggered: view.setCurrentIndex(menu.currentIndex)
                }
            }

            MenuItem {
                text: qsTr("Вийти")
                onTriggered: Qt.quit()
            }
        }
    }

    ListModel {
        id: pagesModel
        ListElement {
            pageName: qsTr("<b>Функція</b>")
            pageSource: "qrc:/qt/qml/lab/app/imports/page/FunctionPage.qml"
        }
        ListElement {
            pageName: qsTr("<b>Профіль студента</b>")
            pageSource: "qrc:/qt/qml/lab/app/imports/page/ProfilePage.qml"
        }
    }

    SwipeView {
        id: view
        interactive: true
        currentIndex: pageTab.currentIndex

        anchors.fill: parent

        onCurrentIndexChanged: {
            let pageInfo = pagesModel.get(view.currentIndex);
            pageLabel.text = pageInfo.pageName;
        }

        Repeater {
            model: pagesModel

            Loader {
                id: pageLoader

                required property string pageName
                required property string pageSource

                asynchronous: true
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem

                source: pageSource

                onLoaded: pageLabel.text = pageName
            }
        }
    }

    footer: TabBar {
        id: pageTab

        currentIndex: view.currentIndex

        width: parent.width
        position: TabBar.Footer

        Repeater {
            model: pagesModel
            delegate: TabButton {

                required property string pageName

                text: pageName
                onClicked: view.setCurrentIndex(pageTab.currentIndex)
            }
        }
    }
}
