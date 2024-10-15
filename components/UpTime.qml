import QtQuick 6.5
import QtQuick.Layouts

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
        anchors.fill: parent
        spacing: 10

        Text{
            text: ""
            font.pointSize: 50
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            Layout.leftMargin: 5
            Layout.rightMargin: 10
            Layout.bottomMargin: 10
            verticalAlignment: Text.AlignVCenter
            font.family: Config.Settings.iconFont.font.family
            color: Config.Settings.palette.color.col600
        }

        ColumnLayout {
            id: hoursMinutes
            Layout.preferredHeight: 56
            Layout.bottomMargin: 8

            Text {
                id: upHours
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                color: Config.Settings.palette.accent.col300
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 34
            }

            Text {
                id: upMinutes
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                color: Config.Settings.palette.accent.col300
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 34
            }
        }

        ColumnLayout {
            Layout.preferredHeight: 56
            Layout.topMargin: 8

            Text {
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                color: Config.Settings.palette.accent.col400
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 20
                text: "hours"
            }

            Text {
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                color: Config.Settings.palette.accent.col400
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 20
                text: "minutes"
            }
        }
    }
}


