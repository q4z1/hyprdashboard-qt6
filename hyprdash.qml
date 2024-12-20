pragma ComponentBehavior: Bound

import QtCore
import QtQuick 6.2
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Effects

import "config" as Config
import "components"

Window {
    id: hyprDashboard
    objectName: "hyprDashboard"
    visibility: Window.Hidden
    flags: Qt.FramelessWindowHint | Qt.Dialog | Qt.WindowStaysOnTopHint
    title: qsTr("hyprdashboard - v0.1 beta")
    color: "transparent"

    Component.onCompleted: { 
        console.log("hyprdash.qml loaded.")
        if(isNerd){
            appUpTimeText.text = "App UpTime: whatever"
            nerdFooter.visible = true
        }
    }

    Timer {
        running: isNerd
        interval: 1000; 
        repeat: true;
        onTriggered: {
            let appUpTime = processor.getAppUpTime()
            appUpTimeText.text = "App UpTime: " + appUpTime["hours"] + "h:" + appUpTime["minutes"] + "m:" + appUpTime["seconds"] + "s"
        }
    }

    readonly property bool portraitMode: Screen.width < Screen.height

    Shortcut {
        sequence: "Escape"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("Esc Key pressed.")
            if(dashboardStackView.depth > 1) dashboardStackView.pop()
            visibility = Window.Hidden;
        }
    }

    Shortcut {
        sequence: "Alt+O"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("Alt+O pressed.")
            if(dashboardStackView.depth > 1) dashboardStackView.pop()
            else dashboardStackView.push(settings)
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Image {
            anchors.fill: parent
            source: "../resources/bg.png"
        }

        // settings button
        // Text {
        //     id: settingsText
        //     y: 16
        //     x: parent.width - 20 - 16
        //     width: 20
        //     height: 20
        //     source: dashboardStackView.currentItem.objectName == 'settingsContent' ? "" : "" // @TODO: proper Icon sources

        //     MouseArea {
        //         id: settingsArea
        //         anchors.fill: parent
        //         hoverEnabled: true
        //         cursorShape: settingsArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
        //         onEntered: parent.color = Config.Settings.palette.accent.col200
        //         onExited: parent.color = Config.Settings.palette.accent.col500
        //         onClicked: { 
        //             if(dashboardStackView.depth > 1) dashboardStackView.pop()
        //             else dashboardStackView.push(settings)
        //          }
        //     }
        // }

        StackView {
            id: dashboardStackView
            anchors.centerIn: parent
            width: parent.width / 12 * 10
            height: parent.height / 8 * 6
            anchors.leftMargin: parent.width / 12
            anchors.rightMargin: parent.width / 12
            anchors.topMargin: parent.height / 8
            anchors.bottomMargin: parent.height / 8
            initialItem: dashBoard
        }

        Component {
            id: dashBoard

            ColumnLayout {
                objectName: "dashboardContent"

                RowLayout {
                    spacing: 15

                    // user, clock, uptime
                    ColumnLayout {
                        spacing: 15
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        User {}
                        Clock { }
                        UpTime { }
                    }

                    // weather & apps 
                    ColumnLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        // Layout.preferredWidth: 280
                        // Layout.minimumHeight: 320
                        spacing: 15

                        Weather { }

                        // apps
                        Box {
                            id: appsBox
                            Layout.minimumWidth: parent.width
                            Layout.minimumHeight: 215
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                            Rectangle {
                                color: "transparent"
                                anchors.fill: parent
                                anchors.margins: 16

                                GridLayout {
                                    columnSpacing: 8
                                    rowSpacing: 12
                                    columns: 4

                                    property var appLaunchers
                                    Component.onCompleted: { 
                                        appLaunchers = gSettings.getValue("appLaunchers") 
                                    }

                                    Repeater {
                                        model: parent.appLaunchers
                                        AppLauncher {
                                            required property var modelData
                                            objectName: modelData["id"]
                                            imageS: modelData["imageS"]
                                            target: modelData["target"]
                                            args: modelData["args"] ? modelData["args"] : null
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // mails, performance
                    ColumnLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        spacing: 15

                        Mail {}
                        Performance {}
                        Locations {}
                    }

                    // actions , rss
                    ColumnLayout {
                        Layout.preferredWidth: 290
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        spacing: 15
                        
                        GridLayout {
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            columns: 2
                            columnSpacing: 15
                            rowSpacing: 15

                            property var actionButtons
                            Component.onCompleted: { 
                                actionButtons = gSettings.getValue("actionButtons") 
                            }

                            Repeater {
                                model: parent.actionButtons
                                ActionButton {
                                    required property var modelData
                                    objectName: modelData["id"]
                                    icon: modelData["icon"]
                                    colorI: modelData["colorI"]
                                    target: modelData["target"]
                                    args: modelData["args"] ? modelData["args"] : null
                                }
                            }
                        }

                        RssReader {}
                    }
                  
                }

                // tile launchers
                RowLayout {
                    id: launchers
                    spacing: 15
                    property var tileLaunchers
                    Component.onCompleted: { 
                        tileLaunchers = gSettings.getValue("tileLaunchers") 
                    }

                    Repeater {
                        model: launchers.tileLaunchers
                        TileLauncher {
                            required property var modelData
                            objectName: modelData["id"]
                            colorB: modelData["colorB"]
                            imageS: modelData["imageS"]
                            imageW: modelData["imageW"]
                            imageH: modelData["imageH"]
                            target: modelData["target"]
                            args: modelData["args"] ? modelData["args"] : null
                        }
                    }
                }
            }
        }

        // settings
        Component {
            id: settings

            ColumnLayout {
                objectName: "settingsContent"
                RowLayout {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height

                    Box {
                        id: settingsBox
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: parent.height
                        Layout.alignment: Qt.AlignTop;
                    }
                }
            }
        }

        // version & app uptime
        RowLayout {
            id: nerdFooter
            width: parent.width - 24
            anchors.margins: 12
            x: 12
            y: parent.height - 36
            height: 36
            visible: false

            Text {
                id: versionText
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter;
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: Config.Settings.palette.accent.col300
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 12
                text: "hyprdash v0.1 beta"
            }

            Text {
                id: appUpTimeText
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter;
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: Config.Settings.palette.accent.col300
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 12
                text: "App UpTime:"
            }
        }
    }
}
