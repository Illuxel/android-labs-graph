pragma ComponentBehavior: Bound
import QtCore
import QtQml
import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Dialogs

import labs.core 1.0

ApplicationWindow {
    id: app
    visible: true

    minimumWidth: 250
    minimumHeight: 325

    // stores name of current json object for saving/load to a file
    property string currentJsonObjectName

    property int headerTextSize: 16
    property int contentTextSize: 14

    property real sideMargins: 8

    property MathFunction mathFunc: MathFunction {
        inputNames: ['x', 'y', 'a']
    }

    // Generating graph from function
    property MathGraph mathGraph: MathGraph {
        step: 0.25
        mathFunc: app.mathFunc
    }

    // Application settings
    property Settings settings: Settings {
        property alias width: app.width
        property alias height: app.height

        property alias x: app.x
        property alias y: app.y

        property alias currentPageIndex: view.currentIndex
        property alias currentFolderPath: app.folderDialog.currentFolder
    }

    property ProgressBar progressBar: ProgressBar {
        value: 0
        visible: value != 0
        enabled: value != 0
        parent: menuBarLayout
        Layout.fillWidth: true
    }

    // Information dialog
    property Dialog msgDialog: Dialog {

        property string topText
        property string detailedText

        parent: app.contentItem
        modal: true
        standardButtons: MessageDialog.Ok
        anchors.centerIn: parent

        contentItem: ColumnLayout {
            spacing: 15
            Label {
                text: app.msgDialog.topText
                font.pixelSize: app.headerTextSize
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            }
            Label {
                text: app.msgDialog.detailedText
                font.pixelSize: app.contentTextSize
                wrapMode: Label.Fit
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
            }
        }
    }

    // Saves/Loads objects that derives JsonInterface
    property SaveManager saveManager: SaveManager {
        folderPath: app.settings.value("currentFolderPath")
        objects: [mathFunc, mathGraph]
    }

    // Open/Save function dialog
    property FolderDialog folderDialog: FolderDialog {
        title: qsTr("Виберіть куди будуть збережені файли")
        modality: Qt.ApplicationModal
        currentFolder: app.settings.value("currentFolderPath", StandardPaths.writableLocation(StandardPaths.DocumentsLocation))
    }

    // Available pages
    property ListModel pagesModel: ListModel {
        ListElement {
            pageID: "function"
            pageName: qsTr("Функція")
            pageSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/page/FunctionPage.qml"
        }
        ListElement {
            pageID: "graph"
            pageName: qsTr("Графік")
            pageSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/page/GraphPage.qml"
        }
    }

    // Optional pages
    property ListModel hiddenPagesModel: ListModel {
        ListElement {
            pageID: "settings"
            pageName: qsTr("Налаштування")
            pageSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/page/SettingsPage.qml"
        }
        ListElement {
            pageID: "profile"
            pageName: qsTr("Студент")
            pageSource: "qrc:/nubip.edu.ua/imports/labs/app/qml/page/ProfilePage.qml"
        }
    }

    Component.onCompleted: {
        if (app.saveManager.isFolderValid()) {
            console.log("Restoring files...");

            if (app.settings.value("autoLoadFunction")) {
                if (app.saveManager.load("function")) {
                    console.log("Function restored");
                } else {
                    console.log("Failed to restore a function");
                }
            } else {
                console.log("Skip function auto load");
            }

            if (app.settings.value("autoLoadGraph")) {
                if (app.saveManager.load("graph")) {
                    console.log("Graph restored");
                } else {
                    console.log("Failed to restore a graph");
                }
            } else {
                console.log("Skip graph auto load");
            }

            console.log("Restoring ended...");
        } else {
            console.log("No folder specified");
            app.folderDialog.open();
        }
    }
    Component.onDestruction: {}

    function showInfoDialog(msg) {
        app.msgDialog.topText = "ℹ️ " + qsTr("Інформація");
        app.msgDialog.detailedText = msg;
        app.msgDialog.open();
        return app.msgDialog.result;
    }
    function showErrorDialog(msg) {
        app.msgDialog.topText = "🚫 " + qsTr("Помилка");
        app.msgDialog.detailedText = msg;
        app.msgDialog.open();
        return app.msgDialog.result;
    }

    //
    function openPageByName(name) {
        // visible pages
        for (let i = 0; i < pagesModel.count; i++) {
            const page = pagesModel.get(i);
            if (page.pageID == name) {
                view.setCurrentIndex(i);
                return;
            }
        }
        // hiddend pages
        for (let i = 0; i < hiddenPagesModel.count; i++) {
            const page = hiddenPagesModel.get(i);
            if (page.pageID == name) {
                pagesModel.insert(0, page);
                view.setCurrentIndex(0);
                return;
            }
        }

        console.log("Page was not found " + name);
    }

    function isHiddenPage() {
        const page = pagesModel.get(view.currentIndex);

        for (let i = 0; i < hiddenPagesModel.count; ++i) {
            const hiddenPage = hiddenPagesModel.get(i);
            if (page.pageID == hiddenPage.pageID)
                return true;
        }

        return false;
    }

    //
    function closeHiddenPages(defaultPageIndex) {
        let count = 0;

        for (let i = 0; i < hiddenPagesModel.count; ++i) {
            const hiddenPage = hiddenPagesModel.get(i);
            for (let j = 0; j < pagesModel.count; ++j) {
                const page = pagesModel.get(j);
                if (page.pageID == hiddenPage.pageID)
                    ++count;
            }
        }

        if (count != 0) {
            pagesModel.remove(0, count);
            tabBar.setCurrentIndex(defaultPageIndex - count);
        }
    }

    SwipeView {
        id: view
        interactive: true
        currentIndex: tabBar.currentIndex

        anchors.fill: parent

        Repeater {
            model: app.pagesModel

            Loader {
                required property string pageName
                required property string pageSource

                asynchronous: true
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                source: pageSource
            }
        }
    }

    menuBar: ToolBar {

        // Top menu
        ColumnLayout {
            id: menuBarLayout
            anchors.fill: parent
            spacing: 0

            RowLayout {
                ToolButton {
                    text: "⋮"
                    font.pointSize: 16
                    font.bold: true

                    onClicked: menu.popup(parent.x, parent.y)
                }
                Label {
                    id: pageLabel
                    text: app.pagesModel.get(view.currentIndex).pageName
                    font.pixelSize: app.headerTextSize
                    font.bold: true
                    horizontalAlignment: Qt.AlignLeft
                }
            }
        }

        Menu {
            id: menu

            // Function
            Menu {
                title: qsTr("Функція")

                MenuItem {
                    text: qsTr("Зберегти")
                    onTriggered: app.saveManager.save("function")
                }
                MenuItem {
                    text: qsTr("Відкрити")
                    onTriggered: app.saveManager.load("function")
                }
                MenuSeparator {}

                MenuItem {
                    text: qsTr("Очистити")
                    onTriggered: app.mathFunc.clear()
                }
            }
            // Graph
            Menu {
                title: qsTr("Графік")

                MenuItem {
                    text: qsTr("Зберегти")
                    onTriggered: app.saveManager.save("graph")
                }
                MenuItem {
                    text: qsTr("Відкрити")
                    onTriggered: app.saveManager.load("graph")
                }

                MenuSeparator {}

                MenuItem {
                    text: qsTr("Очистити")
                    onTriggered: app.mathGraph.clear()
                }
            }

            MenuItem {
                text: qsTr("Студент")
                onTriggered: app.openPageByName("profile")
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("Налаштування")
                onTriggered: app.openPageByName("settings")
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("Вийти")
                onTriggered: {
                    app.settings.sync();
                    Qt.quit();
                }
            }
        }
    }

    footer: TabBar {
        id: tabBar

        currentIndex: view.currentIndex

        width: parent.width
        position: TabBar.Footer

        Repeater {
            model: app.pagesModel

            delegate: TabButton {
                required property string pageID
                required property string pageName
                text: pageName
                font.pixelSize: app.headerTextSize
                font.bold: true

                onClicked: {
                    if (!app.isHiddenPage()) {
                        const currentIndex = tabBar.currentIndex;
                        app.closeHiddenPages(currentIndex);
                    }
                }
            }
        }
    }
}
