pragma ComponentBehavior: Bound

import QtCore
import QtQuick 6.5
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Effects

import "config" as Config
// import "components"

Window {
    id: hyprDashboard
    objectName: "hyprDashboard"

    readonly property bool portraitMode: Screen.width < Screen.height

    // property StartPage startPage: StartPage { }
    // property SideMenu sideMenu: SideMenu {}

    // visibility: Window.FullScreen
    visibility: Window.Hidden
    flags: Qt.FramelessWindowHint | Qt.Dialog | Qt.WindowStaysOnTopHint
    title: qsTr("hyprdashboard - v0.1 alpha")
    color: "transparent"

    Shortcut {
        sequence: "Escape"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("Esc Key pressed.")
            visibility = Window.Hidden;
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        // Rectangle {
        //     anchors.fill: parent
        //     color: Config.Settings.palette.secondary.col700
            
        //     opacity: 0.6
        // }

        Image {
            anchors.fill: parent
            source: "../resources/bg.png"
        }

        Text {
            id: settingsText
            width: parent.width
            leftPadding: 12
            rightPadding: 12
            topPadding: 12
            bottomPadding: 12
            y: 0
            height: 42
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: Config.Settings.palette.secondary.col500
            font.family: Config.Settings.iconFont.font.family
            font.pointSize: 18
            text: ""
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: parent.width / 12
            anchors.rightMargin: parent.width / 12
            anchors.topMargin: parent.height / 8
            anchors.bottomMargin: parent.height / 8

            RowLayout {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height

                Rectangle {
                    id: profileBox
                    Layout.minimumWidth: 256
                    Layout.minimumHeight: 320
                    Layout.alignment: Qt.AlignTop;
                    color: Config.Settings.palette.secondary.col600
                    radius: 15

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.topMargin: 24
                        anchors.bottomMargin: 24
                        spacing: 22

                        Rectangle {
                            Layout.preferredWidth: 172
                            Layout.preferredHeight: 172
                            Layout.alignment: Qt.AlignHCenter
                            color: "transparent"

                            Image {
                                id: profilePic
                                source: "../resources/profile.jpg"
                                anchors.centerIn: parent
                                width: 172
                                height: 172
                                fillMode: Image.PreserveAspectCrop
                                visible: false
                            }

                            MultiEffect {
                                source: profilePic
                                anchors.fill: profilePic
                                maskEnabled: true
                                maskSource:mask
                            }

                            Item {
                                id: mask
                                width: profilePic.width
                                height: profilePic.height
                                layer.enabled: true
                                visible: false

                                Rectangle {
                                    width: profilePic.width
                                    height: profilePic.height
                                    radius: width/2
                                    color: "black"
                                }
                            }
                        }


                        Text {
                            id: userDescText
                            Layout.preferredWidth: parent.width
                            Layout.preferredHeight: 18
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: Config.Settings.palette.secondary.col300
                            font.family: Config.Settings.textFont.font.family
                            font.pointSize: 18
                            font.bold: true
                            text: "Kai Philipp"
                        }

                        Text {
                            id: userNameText
                            Layout.preferredWidth: parent.width
                            Layout.preferredHeight: 14
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: Config.Settings.palette.secondary.col400
                            font.family: Config.Settings.textFont.font.family
                            font.pointSize: 14
                            font.bold: true
                            text: "min"
                        }
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
            color: Config.Settings.palette.secondary.col300
            font.family: Config.Settings.textFont.font.family
            font.pointSize: 12
            text: "hyprdash v0.1 alpha"
        }
    }

}
