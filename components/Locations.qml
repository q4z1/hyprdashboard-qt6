import QtQuick 6.2
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QtCharts

import "../config" as Config
import "../components"

Box {
    id: locationsBox

    Component.onCompleted: { 
        locations = gSettings.getValue("locations")
        processor.checkDiskSpace()
    }

    Connections {
        target: processor

        function onDiskSpaceChanged() { 
            let diskSpace = processor.getDiskSpace()
            pieFree.value = diskSpace["free"]
            freeText.text = diskSpace["free"] + "G"
            pieUsed.value = diskSpace["used"]
            totalText.text = diskSpace["total"] + "G"
            usedText.text = diskSpace["used"] + "G"
            // console.log(JSON.stringify(diskSpace))
        }
    }


    Timer {
        interval: 1000; running: true; repeat: true;
        onTriggered: processor.checkDiskSpace()
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

            ColumnLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredHeight: 24
                RowLayout {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredHeight: 12
                    Text {
                        Layout.preferredHeight: 12
                        font.pointSize: 12
                        font.family: Config.Settings.textFont.font.family
                        color: Config.Settings.palette.color.col600
                        text: "total:"
                    }

                    Text {
                        id: totalText
                        Layout.preferredHeight: 12
                        font.pointSize: 12
                        font.family: Config.Settings.textFont.font.family
                        color: Config.Settings.palette.color.col600
                    }
                }
                RowLayout {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.preferredHeight: 12
                    Text {
                        Layout.preferredHeight: 12
                        font.pointSize: 12
                        font.family: Config.Settings.textFont.font.family
                        color: Config.Settings.palette.color.col500
                        text: " free:"
                    }
                    
                    Text {
                        id: freeText
                        Layout.fillWidth: true
                        Layout.preferredHeight: 12
                        font.pointSize: 12
                        font.family: Config.Settings.textFont.font.family
                        color: Config.Settings.palette.color.col500
                    }
                    
                }

                RowLayout {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.preferredHeight: 12
                    Text {
                        Layout.preferredHeight: 12
                        font.pointSize: 12
                        font.family: Config.Settings.textFont.font.family
                        color: Config.Settings.palette.color.col400
                        text: " used:"
                    }
                    
                    Text {
                        id: usedText
                        Layout.fillWidth: true
                        Layout.preferredHeight: 12
                        font.pointSize: 12
                        font.family: Config.Settings.textFont.font.family
                        color: Config.Settings.palette.color.col400
                    }
                    
                }

            }

            ChartView {
                id: chart
                Layout.preferredWidth:  72
                Layout.preferredHeight: 72
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                backgroundColor: "transparent"
                
                legend.visible: false
                antialiasing: true

                plotArea:  Qt.rect(0, 0, 72, 72) 

                PieSeries {
                    id: pieSeries
                    PieSlice { id: pieFree; color: Config.Settings.palette.color.col500; }
                    PieSlice { id: pieUsed; color: Config.Settings.palette.color.col400; }
                }
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
                color: "transparent"

                GridLayout{
                    id: gridFolders
                    anchors.fill: parent
                    columns: 2
                    columnSpacing: 2
                    rowSpacing: 8

                    property var locations
                    Component.onCompleted: { 
                        locations = gSettings.getValue("locations") 
                    }

                    Repeater {
                        model: parent.locations.folders
                        Item {
                            required property var modelData
                            objectName: modelData["id"]
                            
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            Layout.preferredHeight: 32
                            Layout.preferredWidth: parent.width / 2

                            RowLayout {
                                spacing: 4
                                Component.onCompleted: { 
                                    let colors = modelData["color"].split(".")
                                    folderIcon.color = Config.Settings.palette[colors[0]][colors[1]]
                                    folderText.color = Config.Settings.palette[colors[0]][colors[1]]
                                }
                                IconImage {
                                    id: folderIcon
                                    Layout.preferredHeight: 32
                                    Layout.preferredWidth: 32
                                    source: modelData["icon"]
                                }
                                Text {
                                    id: folderText
                                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                    Layout.preferredHeight: 12
                                    horizontalAlignment: Text.AlignLeft
                                    font.family: Config.Settings.textFont.font.family
                                    font.pointSize: 12
                                    text: modelData["label"]
                                }
                            }

                            MouseArea {
                                id: folderArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: folderArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onEntered: {
                                    folderIcon.color = Config.Settings.palette.accent.col200
                                    folderText.color = Config.Settings.palette.accent.col200

                                }
                                onExited: {
                                    let colors = modelData["color"].split(".")
                                    folderIcon.color = Config.Settings.palette[colors[0]][colors[1]]
                                    folderText.color = Config.Settings.palette[colors[0]][colors[1]]
                                }
                                onClicked: { 
                                    processor.launch(locations.fileManager, modelData["args"])
                                    hyprDashboard.visibility = Window.Hidden
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}