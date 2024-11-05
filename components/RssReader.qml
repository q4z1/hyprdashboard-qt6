import QtQuick 6.5
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import "../components"
import "../config" as Config

Box {
    id: rssReaderBox

    Connections {
        target: processor

        function onFeedsChanged() { 
            feeds = processor.getFeeds()
            for(let i in feedSettings){
                let entries = Object.entries(feedSettings[i])
                let key = entries[0][0]
                if(key != 0 && typeof feeds[key] === 'undefined')
                    feeds[key] = []
            }
            feedsContent.model = feedSettings
        }
    }

    Timer {
        interval: 300000; running: true; repeat: true;
            onTriggered: processor.checkFeeds()
    }

    property var feeds
    property var feedSettings
    Component.onCompleted: { 
        processor.checkFeeds()
        let fS = gSettings.getValue("rss")
        feedSettings = []
        for(let i in fS){
            let entries = Object.entries(fS[i])
            feedSettings.push(entries[0][0])
        }
        rssBar.model = feedSettings
        // console.log("feedSettings", feedSettings)
    }

    Layout.preferredWidth: 305
    Layout.preferredHeight: 215
    Layout.alignment: Qt.AlignTop

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width - 20
        height: parent.height - 30

        RssTabBar {
            id: rssBar
        }

        StackLayout {
            currentIndex: rssBar.currentIndex
            Repeater {
                id: feedsContent
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height

                Item {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height

                    ScrollView {
                        anchors.fill: parent

                        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                        ScrollBar.vertical.contentItem: Rectangle {
                            implicitWidth: 8
                            color: Config.Settings.palette.accent.col200
                        }

                        ScrollBar.vertical.background: Rectangle {
                            anchors.fill: parent
                            color: Config.Settings.palette.accent.col400
                        }

                        ColumnLayout {
                            width: parent.width
                        
                            Repeater{
                                id: feedRow
                                model: feeds[modelData]
                            
                                Rectangle {
                                    id: feedRect
                                    color: "transparent"
                                    Layout.preferredWidth: 285
                                    Layout.maximumWidth: 285
                                    Layout.preferredHeight: 24
                                    Layout.topMargin: 2
                                    required property string title
                                    required property string description
                                    required property string link
                                    Column {
                                        id: feedItem
                                        anchors.fill: parent
                                        spacing: 2

                                        Text {
                                            id: feedTitle
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            wrapMode: Text.WordWrap
                                            padding: 3
                                            height: 12
                                            text: title
                                            color: Config.Settings.palette.accent.col300
                                            font.bold: true
                                            font.pointSize: 8
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            id: feedDesc
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            wrapMode: Text.WordWrap
                                            padding: 3
                                            height: 12
                                            text: description
                                            color: Config.Settings.palette.accent.col400
                                            font.pointSize: 8
                                            elide: Text.ElideRight
                                        }
                                    }
                                    MouseArea {
                                        id: mouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: { 
                                            processor.openUrlExternally(link)
                                            hyprDashboard.visibility = Window.Hidden
                                        }
                                        onEntered: {
                                            feedDesc.color = Config.Settings.palette.accent.col300
                                            feedTitle.color = Config.Settings.palette.accent.col100

                                        }
                                        onExited: {
                                            feedDesc.color = Config.Settings.palette.accent.col400
                                            feedTitle.color = Config.Settings.palette.accent.col300
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}