import QtQuick 6.5
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import "../components"
import "../config" as Config

Box {
    id: launcherBox
    required property string target
    required property color colorB
    property string args
    property alias imageS: image.source
    property alias imageW: image.width
    property alias imageH: image.height

    Layout.minimumWidth: 145
    Layout.minimumHeight: 145
    Layout.alignment: Qt.AlignTop;
    color: colorB

    Image {
        id: image
        anchors.centerIn: launcherBox
        width: parent.width - 8
        height: parent.height - 8
        fillMode: Image.PreserveAspectCrop
        visible: false
    }

    MultiEffect {
        source: image
        anchors.fill: image
        maskEnabled: true
        maskSource: mask
    }

    Item {
        id: mask
        width: image.width
        height: image.height
        layer.enabled: true
        visible: false

        Rectangle {
            width: image.width
            height: image.height
            radius: 15
            color: "#000000"
        }
    }

    MouseArea {
        id: launcherArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: launcherArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
        onEntered: hoverlay.opacity = 0.4
        onExited: hoverlay.opacity = 0
        onClicked: { 
            if(target.includes("://")) processor.openUrlExternally(target)
            else processor.launch(target, args)
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