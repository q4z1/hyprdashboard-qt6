import QtQuick 6.5
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import "../components"
import "../config" as Config

Rectangle {
    id: appBox
    required property string target
    property string args
    property alias imageS: image.source

    color: "transparent"
    Layout.minimumWidth: 56
    Layout.minimumHeight: 56
    Layout.alignment: Qt.AlignTop;

    Image {
        id: image
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
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
            radius: 28
            color: "#000000"
        }
    }

    MouseArea {
        id: appArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: appArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
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
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        opacity: 0
        color: "#ffffff"
        radius: 32
    }

}