import QtQuick 6.5
import QtQuick.Layouts
import QtQuick.Effects

import "../config" as Config
import "../components"

Box {
    required property string target
    property string args
    property int rotation
    property string colorI
    property alias textI: actionText.text
    property alias sizeI: actionText.font.pointSize

    Layout.minimumWidth: 145
    Layout.minimumHeight: 145
    Layout.alignment: Qt.AlignTop

    Text {
        id: actionText
        anchors.centerIn: parent
        font.family: Config.Settings.iconFont.font.family
        transform: Rotation { origin.x: 36; origin.y: 36; angle: rotation}
        Component.onCompleted: { 
            let colors = colorI.split(".")
            actionText.color =  Config.Settings.palette[colors[0]][colors[1]]
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


