pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import labs.core 1.0

import "js/utils.js" as Utils

ApplicationWindow {
    id: app
    visible: true

    minimumWidth: 250
    minimumHeight: 325

    // Application settings
    property Settings settings: Settings {
        category: "appSettings"

        property alias width: app.width
        property alias height: app.height

        property alias x: app.x
        property alias y: app.y

        property alias filePath: app.fileDialog.currentFile

        property alias currentPageIndex: view.currentIndex
        property alias currentMathIndex: app.mathFunc.currentIndex
    }

    // Math Function object
    property MathFunction mathFunc: MathFunction {
        step: 0.5
        range: Qt.vector2d(0., 10.)
        names: ['x', 'y', 'a']
    }

    // Save math function
    property SaveManager saveManager: SaveManager {
        fileName: "function.json"
        functionObject: mathFunc
    }

    // Open/Save function dialog
    property FileDialog fileDialog: FileDialog {
        modality: Qt.ApplicationModal
        nameFilters: ["JSON files (*.json)"]
        currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        currentFile: app.saveManager.fileName

        onAccepted: {
            let isWorked = false;

            if (fileMode == FileDialog.SaveFile) {
                isWorked = app.saveManager.save(currentFile);

                if (!isWorked) {
                    Utils.openErrorDialog(msgDialog, qsTr("Сталася помилка при збереженні файлу"));
                } else {
                    var urlObject = new URL(currentFile);
                    Utils.openInfoDialog(msgDialog, qsTr("Файл збережено до " + urlObject.pathname));
                }
            } else {
                isWorked = app.saveManager.load(currentFile);

                if (!isWorked) {
                    Utils.openErrorDialog(msgDialog, qsTr("Сталася помилка при завантаженні файлу"));
                } else {
                    Utils.openInfoDialog(msgDialog, qsTr("Файл завантажено"));
                }
            }
        }
    }

    // Information dialog
    property Dialog msgDialog: Dialog {

        property string topText
        property string detailedText

        modal: true
        standardButtons: MessageDialog.Ok
        anchors.centerIn: parent

        contentItem: ColumnLayout {
            spacing: 15
            Label {
                text: msgDialog.topText
                font.pixelSize: 16
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            }
            Label {
                text: msgDialog.detailedText
                font.pixelSize: 14
                wrapMode: Label.Fit
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
            }
        }
    }

    // Construction
    Component.onCompleted: {}
    // Destruction
    Component.onDestruction: {}

    // Available tabs
    ListModel {
        id: pagesModel
        ListElement {
            pageName: qsTr("<b>Функція</b>")
            pageSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/page/FunctionPage.qml"
        }
        // ListElement {
        //     pageName: qsTr("<b>3D графік</b>")
        //     pageSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/page/GraphPage.qml"
        // }
        ListElement {
            pageName: qsTr("<b>Студент</b>")
            pageSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/page/ProfilePage.qml"
        }
    }

    menuBar: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("<b>⋮</b>")
                font.pointSize: 14

                onClicked: menu.popup(parent.x, parent.y)
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

            MenuItem {
                text: qsTr("Зберегти функцію")
                onTriggered: {
                    app.fileDialog.fileMode = FileDialog.SaveFile;
                    app.fileDialog.open();
                }
            }

            MenuItem {
                text: qsTr("Відкрити функцію")
                onTriggered: {
                    app.fileDialog.fileMode = FileDialog.OpenFile;
                    app.fileDialog.open();
                }
            }

            MenuItem {
                text: qsTr("Вийти")
                onTriggered: Qt.quit()
            }
        }
    }

    SwipeView {
        id: view
        interactive: true
        currentIndex: app.settings.currentPageIndex

        anchors.fill: parent

        onCurrentIndexChanged: {
            const pageInfo = pagesModel.get(view.currentIndex);
            pageLabel.text = pageInfo.pageName;
            app.settings.currentPageIndex = view.currentIndex;
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
