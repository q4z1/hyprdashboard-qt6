import QtQuick 6.2
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import "../components"
import "../config" as Config

Box {
    id: userBox

    property var userInfo
    Component.onCompleted: { userInfo = gSettings.getValue("userInfo") }

    Layout.minimumWidth: 256
    Layout.minimumHeight: 303
    Layout.alignment: Qt.AlignLeft | Qt.AlignTop

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 24
        anchors.bottomMargin: 24
        spacing: 20

        Rectangle {
            Layout.preferredWidth: 172
            Layout.preferredHeight: 172
            Layout.alignment: Qt.AlignHCenter
            color: "transparent"

            Image {
                id: profilePic
                source: userInfo["pic"]
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
            Layout.preferredHeight: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: Config.Settings.palette.color.col800
            font.family: Config.Settings.textFont.font.family
            font.pointSize: 20
            text: userInfo["desc"]
        }

        Text {
            id: userNameText
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 16
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: Config.Settings.palette.color.col600
            font.family: Config.Settings.textFont.font.family
            font.pointSize: 16
            font.bold: true
            text: userInfo["user"]
        }
    }
}