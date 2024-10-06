pragma ComponentBehavior: Bound

import QtCore
import QtQuick 6.5
import QtQuick.Controls
import QtQuick.Layouts

// import "config" as Config
// import "pages"
// import "components"

ApplicationWindow {

    readonly property bool portraitMode: mainWindow.width < mainWindow.height

    // property StartPage startPage: StartPage { }
    // property SideMenu sideMenu: SideMenu {}

    id: mainWindow
    width: 854
    height: 480
    visible: true
    title: qsTr("hyprdashboard - v0.1 alpha")

    Rectangle {
        anchors.fill: parent
        color: "red"

        Text {
            color: "white"
            text: "hyprdash v0.1 alpha"
        }
    }

}
