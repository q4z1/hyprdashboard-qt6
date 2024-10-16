import QtQuick 6.5
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts

import "../config" as Config
import "../components"

Box {
    required property string target
    property string args
    property int rotation
    property string colorI
    property alias icon: actionIcon.source

    Layout.minimumWidth: 145
    Layout.minimumHeight: 145
    Layout.alignment: Qt.AlignTop

    IconImage {
        id: actionIcon
        anchors.centerIn: parent
        width: 56
        height: 56
        Component.onCompleted: { 
            let colors = colorI.split(".")
            actionIcon.color =  Config.Settings.palette[colors[0]][colors[1]]
        }

    }

    MouseArea {
        id: actionArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: actionArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
        onEntered: hoverlay.opacity = 0.4
        onExited: hoverlay.opacity = 0
        onClicked: { 
            processor.launch(target, args)
            hyprDashboard.visibility = Window.Hidden
        }
    }

    Rectangle {
        id: hoverlay
        anchors.fill: parent
        opacity: 0
        color: "#ffffff"
        radius: parent.radius
    }
}


