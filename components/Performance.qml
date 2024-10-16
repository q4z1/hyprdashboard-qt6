import QtQuick 6.5
import QtQuick.Controls
import QtQuick.Layouts

import "../config" as Config
import "../components"

Box {
    id: performanceBox

    Connections {
        target: processor

        function onPerformanceChanged() { 
            performance = processor.getPerformance()
            cpu.text = performance["cpu"] + "%"
            cpuBar.value = performance["cpu"]
            ram.text = performance["ram"] + "%"
            ramBar.value = performance["ram"]
            temp.text = performance["temp"] + "°C"
            // console.log(JSON.stringify(performance))
        }
    }

    Component.onCompleted: { 
        processor.checkPerformance()
    }

    Timer {
        interval: 1000; running: true; repeat: true;
        onTriggered: processor.checkPerformance()
    }

    property var performance

    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    Layout.preferredWidth: 280
    Layout.preferredHeight: 213

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        RowLayout{
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.preferredWidth: 240
            Layout.preferredHeight: 40
            spacing: 15

            IconImage {
                id: cpuIcon
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                color: Config.Settings.palette.color.col300
                source: "../resources/cpu.svg"
            }

            ProgressBar {
                id: cpuBar
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 12
                from: 0
                to: 100
                contentItem: Rectangle {
                    height: 10
                    width: cpuBar.width * (cpuBar.value / 100)
                    color: cpuBar.value === 0.0 ? "transparent" : Config.Settings.palette.color.col300
                }
            }

            Text{
                id: cpu
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredWidth: 64
                verticalAlignment: Text.AlignVCenter;
                font.pointSize: 14
                Layout.preferredHeight: 40
                font.family: Config.Settings.textFont.font.family
                color: Config.Settings.palette.color.col300
            }
        }

        RowLayout{
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.preferredWidth: 240
            Layout.preferredHeight: 40
            spacing: 15

            IconImage {
                id: ramIcon
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                color: Config.Settings.palette.color.col500
                source: "../resources/ram.svg"
            }

            ProgressBar {
                id: ramBar
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 12
                from: 0
                to: 100
                contentItem: Rectangle {
                    height: 8
                    width: ramBar.width * (ramBar.value / 100)
                    color: ramBar.value === 0.0 ? "transparent" : Config.Settings.palette.color.col500 
                }
            }

            Text{
                id: ram
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredWidth: 64
                verticalAlignment: Text.AlignVCenter;
                font.pointSize: 14
                Layout.preferredHeight: 40
                font.family: Config.Settings.textFont.font.family
                color: Config.Settings.palette.color.col500
            }
        }

        RowLayout{
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.preferredWidth: 240
            Layout.preferredHeight: 40
            spacing: 15

            IconImage {
                id: tempIcon
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                color: Config.Settings.palette.color.col400
                source: "../resources/temperature.svg"
            }

            Text{
                id: temp
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignLeft;
                font.pointSize: 16
                Layout.preferredHeight: 40
                font.family: Config.Settings.textFont.font.family
                color: Config.Settings.palette.color.col400
            }
        }
    }
}


