import QtQuick 6.5
import QtQuick.Layouts

import "../config" as Config
import "../components"

Box {
    id: performanceBox

    Connections {
        target: processor

        function onPerformanceChanged() { 
            performance = processor.getPerformance()
            cpu.text = "CPU: " + performance["cpu"] + "%"
            ram.text = "RAM: " + performance["ram"] + "%"
            temp.text = "Temp: " + performance["temp"] + "°C"
            // console.log(JSON.stringify(performance))
        }
    }

    Component.onCompleted: { 
        processor.checkPerformance()
    }

    Timer {
        interval: 2500; running: true; repeat: true;
        onTriggered: processor.checkPerformance()
    }

    property var performance

    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    Layout.preferredWidth: 280
    Layout.preferredHeight: 213

    Column{
        anchors.centerIn: parent
        anchors.margins: 16
        spacing: 8

        Text{
            id: cpu
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            font.pointSize: 14
            Layout.preferredWidth: parent.width - 16
            Layout.preferredHeight: 14
            font.family: Config.Settings.iconFont.font.family
            color: Config.Settings.palette.color.col300
        }

        Text{
            id: ram
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            font.pointSize: 14
            Layout.preferredWidth: parent.width -16
            Layout.preferredHeight: 14
            font.family: Config.Settings.iconFont.font.family
            color: Config.Settings.palette.color.col600
        }

        Text{
            id: temp
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            font.pointSize: 14
            Layout.preferredWidth: parent.width - 16
            Layout.preferredHeight: 14
            font.family: Config.Settings.iconFont.font.family
            color: Config.Settings.palette.color.col400
        }
    }
}


