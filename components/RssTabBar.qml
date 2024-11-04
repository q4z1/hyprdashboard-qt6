import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../config" as Config

TabBar {
    id: rssTabBar

    property alias model: tabButtons.model

    Layout.preferredWidth: parent.width
    currentIndex: 0

    background: Rectangle {
        color:  Config.Settings.palette.accent.col600
    }

    Repeater{
        id: tabButtons

        TabButton {
            id: tabButton

            property bool isHovered: false

            height: 24
            padding: 0
            contentItem: Text {
                text: modelData
                color: rssTabBar.currentIndex === index || tabButton.isHovered ?  Config.Settings.palette.accent.col100 :  Config.Settings.palette.accent.col200
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: rssTabBar.currentIndex === index || tabButton.isHovered ?  Config.Settings.palette.accent.col500 :  Config.Settings.palette.accent.col600
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: rssTabBar.currentIndex === index && tabButton.isHovered ? Qt.ArrowCursor : Qt.PointingHandCursor

                onClicked: {
                    rssTabBar.currentIndex = index
                }

                onEntered: {
                    tabButton.isHovered = true
                }

                onExited: {
                    tabButton.isHovered = false
                }
            }
        }
    }


}