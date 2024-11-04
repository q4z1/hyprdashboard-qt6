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
            feedsContent.updateFeeds()
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
                signal updateFeeds

                onUpdateFeeds: {
                    // console.log("onUpdateFeeds", JSON.stringify(feeds))
                    // feedRow.model = feeds[modelData]
                }

                Item {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height

                    ColumnLayout {
                        width: parent.width
                       
                        Repeater{
                            id: feedRow
                            model: feeds[modelData]
                           
                            Column {
                                id: feedItem
                                Layout.preferredWidth: 285
                                Layout.maximumWidth: 285
                                Layout.maximumHeight: 36
                                spacing: 2
                                required property string title
                                required property string description
                                required property string link
                                Text {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    wrapMode: Text.WordWrap
                                    height: 12
                                    text: title
                                    color: Config.Settings.palette.accent.col200
                                    font.bold: true
                                    font.pointSize: 8
                                    elide: Text.ElideRight
                                }
                                Text {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    wrapMode: Text.WordWrap
                                    height: 12
                                    text: description
                                    color: Config.Settings.palette.accent.col300
                                    font.pointSize: 8
                                    elide: Text.ElideRight
                                }
                            }
                            Component.onCompleted: { 
                                // console.log("feeds[modelData]", JSON.stringify(feeds[modelData]))
                            }
                        }
                    }

                }
            }
        }
    }



}