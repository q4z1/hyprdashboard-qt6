pragma ComponentBehavior: Bound

import QtCore
import QtQuick 6.5
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import "config" as Config
// import "components"

Window {
    id: hyprDashboard
    objectName: "hyprDashboard"

    readonly property bool portraitMode: Screen.width < Screen.height

    // property StartPage startPage: StartPage { }
    // property SideMenu sideMenu: SideMenu {}

    // visibility: Window.FullScreen
    visibility: Window.Hidden
    flags: Qt.FramelessWindowHint | Qt.Dialog | Qt.WindowStaysOnTopHint
    title: qsTr("hyprdashboard - v0.1 alpha")
    color: "transparent"

    Shortcut {
        sequence: "Escape"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("exit shortcut pressed.")
            // visible = false
            visibility = Window.Hidden;
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: Config.Settings.palette.secondary.col700
            opacity: 0.6
        }

        Text {
            id: versionText
            width: parent.width
            topPadding: 8
            bottomPadding: 8
            y: parent.height - 28
            height: 28
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: Config.Settings.palette.secondary.col300
            text: "hyprdash v0.1 alpha"
        }
    }

}
