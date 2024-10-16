import QtQuick 6.5
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import "../config" as Config
import "../components"

Box {
    id: locationsBox

    Component.onCompleted: { 
        locations = gSettings.getValue("locations")
    }

    property var locations

    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    Layout.preferredWidth: 280
    Layout.preferredHeight: 215

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16

        RowLayout {
            Layout.preferredWidth:  parent.width - 32
            Layout.preferredHeight: 72
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            spacing: 10

            IconImage {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredWidth: 64
                Layout.preferredHeight: 64
                color: Config.Settings.palette.color.col500
                source: "../resources/ssd.svg"
            }

            Rectangle {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                Layout.preferredHeight: 72
                radius: 5
                color: Config.Settings.palette.accent.col400
            }
        }

        RowLayout {
            Layout.preferredWidth:  parent.width - 32
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            Rectangle {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                Layout.preferredHeight: 72
                radius: 5
                color: Config.Settings.palette.accent.col400
            }
        }
    }
}