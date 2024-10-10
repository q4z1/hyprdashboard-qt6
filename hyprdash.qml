pragma ComponentBehavior: Bound

import QtCore
import QtQuick 6.5
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
    title: qsTr("hyprdashboard - v0.1 alpha")
    color: "transparent"

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
        sequence: "Alt+S"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("Alt+S pressed.")
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
        Text {
            id: settingsText
            y: 16
            x: parent.width - 20 - 16
            width: 20
            height: 20
            horizontalAlignment: Text.AlignCenter
            verticalAlignment: Text.AlignVCenter
            color: Config.Settings.palette.accent.col500
            font.family: Config.Settings.iconFont.font.family
            font.pointSize: 20
            text: dashboardStackView.currentItem.objectName == 'settingsContent' ? "" : ""

            MouseArea {
                id: settingsArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: settingsArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                onEntered: parent.color = Config.Settings.palette.accent.col200
                onExited: parent.color = Config.Settings.palette.accent.col500
                onClicked: { 
                    if(dashboardStackView.depth > 1) dashboardStackView.pop()
                    else dashboardStackView.push(settings)
                 }
            }
        }

        StackView {
            id: dashboardStackView
            anchors.fill: parent
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
                    // profile, clock & weather

                    User {}

                    ColumnLayout {
                        id: apps
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop;
                        Layout.preferredWidth: 280
                        Layout.minimumHeight: 320
                        spacing: 15

                        ClockBox { }
                        
                        Box {
                            id: appsBox
                            Layout.minimumWidth: parent.width
                            Layout.minimumHeight: 240

                            Rectangle {
                                color: "transparent"
                                anchors.fill: parent
                                anchors.margins: 16

                                GridLayout {
                                    columnSpacing: 16
                                    rowSpacing: 16
                                    columns: 3

                                    // whatsapp
                                    AppLauncher {
                                        id: whatsapp
                                        imageS: "../resources/whatsapp.svg"
                                        target: "chromium"
                                        args: "--profile-directory=Default --app-id=hnpfjngllnobngcgfapefoaidbinmjnm"
                                    }

                                    // terminal
                                    AppLauncher {
                                        id: terminal
                                        imageS: "../resources/terminal.svg"
                                        target: "kitty"
                                    }

                                    // discord
                                    AppLauncher {
                                        id: discord
                                        imageS: "../resources/discord.svg"
                                        target: "discord"
                                    }

                                    // firefox
                                    AppLauncher {
                                        id: firefox
                                        imageS: "../resources/firefox.svg"
                                        target: "firefox"
                                    }

                                    // code
                                    AppLauncher {
                                        id: code
                                        imageS: "../resources/code.svg"
                                        target: "code"
                                    }

                                    // gimp
                                    AppLauncher {
                                        id: gimp
                                        imageS: "../resources/gimp.svg"
                                        target: "gimp"
                                    }

                                    // inkscape
                                    AppLauncher {
                                        id: incscape
                                        imageS: "../resources/inkscape.svg"
                                        target: "inkscape"
                                    }

                                    // nnn
                                    AppLauncher {
                                        id: nnn
                                        imageS: "../resources/files.svg"
                                        target: "kitty"
                                        args: "-e nnn ~"
                                    }
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    id: launchers
                    spacing: 15

                    // netflix
                    TileLauncher {
                        id: netflix
                        colorB: "#000000"
                        imageS: "../resources/netflix.svg"
                        target: "https://www.netflix.com"
                    }

                    // geforcenow
                    TileLauncher {
                        id: geforcenow
                        colorB: "#000000"
                        imageS: "../resources/geforcenow.jpg"
                        imageW: 145
                        imageH: 145
                        target: "chromium"
                        args: "--profile-directory=Default --app-id=egmafekfmcnknbdlbfbhafbllplmjlhn"
                    }

                    // tagesschau
                    TileLauncher {
                        id: tagesschau
                        colorB: "#dddddd"
                        imageS: "../resources/tagesschau.svg"
                        imageW: 145
                        imageH: 145
                        target: "https://tagesschau.de"
                    }

                    // scinexx
                    TileLauncher {
                        id: scinexx
                        colorB: "#dddddd"
                        imageS: "../resources/scinexx.png"
                        imageW: 145
                        imageH: 145
                        target: "https://scinexx.de"
                    }
                }
            }
        }

        Component {
            id: settings

            ColumnLayout {
                objectName: "settingsContent"
                RowLayout {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height

                    Box {
                        id: userBox
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: parent.height
                        Layout.alignment: Qt.AlignTop;
                    }
                }
            }
        }

        Text {
            id: versionText
            width: parent.width
            topPadding: 12
            bottomPadding: 12
            y: parent.height - 36
            height: 36
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: Config.Settings.palette.accent.col300
            font.family: Config.Settings.textFont.font.family
            font.pointSize: 12
            text: "hyprdash v0.1 alpha"
        }
    }

}
