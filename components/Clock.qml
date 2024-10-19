import QtQuick 6.5
import QtQuick.Layouts
import QtQuick.Effects

import "../config" as Config
import "../components"

Box {
    id: clock

    Component.onCompleted: { 
        clock.timeChanged()
    }

    Timer {
        interval: 1000; running: true; repeat: true;
        onTriggered: clock.timeChanged()
    }
    
    property string day
    property string date
    property string hours
    property string minutes
    property string seconds

    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    Layout.minimumWidth: 256
    Layout.minimumHeight: 100

    RowLayout {
        spacing: 8
        anchors.fill: parent
        anchors.margins: 16

        Item {
            id: hoursText
            Layout.preferredWidth: parent.width / 5
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            Text {
                anchors.fill: parent
                color: Config.Settings.palette.color.col700
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 40
                text: clock.hours
            }
        }

        Item {
            Layout.preferredWidth: parent.width / 5
            Layout.preferredHeight: parent.height

            ColumnLayout {
                id: minutesSeconds
                anchors.fill: parent

                Text {
                    Layout.preferredHeight: 12
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    color: Config.Settings.palette.color.col300
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 16
                    text: clock.seconds
                }

                Text {
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    color: Config.Settings.palette.color.col500
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 40
                    text: clock.minutes
                }
            }
        }

        Item {
            id: dayDateText
            Layout.preferredWidth: parent.width / 2
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Text {
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    color: Config.Settings.palette.color.col400
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 16
                    text: clock.day
                }

                Text {
                    Layout.preferredHeight: 14
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    color: Config.Settings.palette.color.col200
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 14
                    text: clock.date
                }
            }
        }
    }

    function timeChanged() {
        var d = new Date
        hours = (d.getHours() < 10) ? "0" + d.getHours() : d.getHours()
        minutes = (d.getMinutes() < 10) ? "0" + d.getMinutes() : d.getMinutes()
        seconds = (d.getSeconds() < 10) ? "0" + d.getSeconds() : d.getSeconds()
        day = d.toLocaleDateString(Qt.locale(), 'dddd,');   
        date = d.toLocaleDateString(Qt.locale(), 'dd.MM.yy');   
    }
}


