import QtQuick 6.5
import QtQuick.Layouts
import QtQuick.Controls

import "../config" as Config
import "../components"

Box {
    id: upTimeBox

    Connections {
        target: processor

        function onUpTimeChanged() { 
            upTime = processor.getUpTime()
            upHours.text = upTime["hours"]
            upMinutes.text = upTime["minutes"]
            // console.log(JSON.stringify(upTime))
        }
    }

    Component.onCompleted: { 
        processor.checkUpTime()
    }

    Timer {
        interval: 60000; running: true; repeat: true;
        onTriggered: processor.checkUpTime()
    }

    property var upTime

    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    Layout.preferredWidth: 256
    Layout.preferredHeight: 100

    RowLayout{
        anchors.centerIn: parent
        width: parent.width - 32
        height: parent.height - 32
        spacing: 10

        IconImage {
            Layout.preferredWidth: 60
            Layout.preferredHeight: 60
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            width: 56
            height: 56
            color: Config.Settings.palette.color.col600
            source: "../resources/timer.svg"
        }

        ColumnLayout {
            id: hoursMinutes
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            spacing: 0

            Text {
                id: upHours
                Layout.preferredHeight: 30
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                verticalAlignment: Text.AlignBottom
                color: Config.Settings.palette.accent.col300
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 32
            }

            Text {
                id: upMinutes
                Layout.preferredHeight: 30
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                verticalAlignment: Text.AlignTop
                color: Config.Settings.palette.accent.col300
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 32
            }
        }

        ColumnLayout {
            Layout.preferredHeight: parent.height

            Text {
                Layout.preferredHeight: 30
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                verticalAlignment: Text.AlignBottom
                color: Config.Settings.palette.accent.col400
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 20
                text: "hours"
            }

            Text {
                Layout.preferredHeight: 30
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                verticalAlignment: Text.AlignTop
                color: Config.Settings.palette.accent.col400
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 20
                text: "minutes"
            }
        }
    }
}


