import QtQuick 6.2
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import "../config" as Config
import "../components"

import "../js/helpers.js" as Helpers

Box {
    id: mailBox

    property var mails
    property var mailSettings

    Connections {
        target: processor

        function onMailsChanged() { 
            let mailsObject = processor.getMails()
            let mailsTempArray = []
            let provider = Object.keys(mailsObject)
            for(let i=0; i<provider.length; i++) {
                mailsTempArray.push({
                    "provider": provider[i],
                    "unread": mailsObject[provider[i]]["unread"],
                    "icon": mailsObject[provider[i]]["icon"],
                    "webmail": mailsObject[provider[i]]["webmail"]
                })
            }
            mails = mailsTempArray
            // console.log(JSON.stringify(mails))
        }
    }

    Component.onCompleted: { 
        processor.checkMails()
    }

    Timer {
        interval: 300000; running: true; repeat: true;
            onTriggered: processor.checkMails()
    }

    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    Layout.preferredWidth: 280
    Layout.preferredHeight: 76
 
    RowLayout{
        id: row
        anchors.centerIn: parent
        spacing: 16

        Repeater {
            model: mails

            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            Rectangle {
                required property var modelData

                objectName: modelData["provider"]
                color: "transparent"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.minimumWidth: 72
                Layout.minimumHeight: 44

                Row {
                    id: mailItem
                    spacing: 10
                    anchors.centerIn: parent

                    IconImage {
                        width: 44
                        height: 44
                        source: modelData["icon"]
                    }

                    Text {
                        id: mailText
                        height: 44
                        color: Config.Settings.palette.accent.col300
                        font.family: Config.Settings.textFont.font.family
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 28
                        text: modelData["unread"]
                    }
                }

                MouseArea {
                    id: mailArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: mailArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onEntered: mailText.color = Config.Settings.palette.accent.col100
                    onExited: mailText.color = Config.Settings.palette.accent.col300
                    onClicked: { 
                        // console.log("webmail", modelData["webmail"])
                        processor.openUrlExternally(modelData["webmail"])
                        hyprDashboard.visibility = Window.Hidden
                    }
                }
            }
        }
    }

}


