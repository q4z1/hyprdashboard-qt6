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
            feedsContent.model = feeds
            // console.log("feeds", JSON.stringify(feeds))
            // console.log("feedSettings", JSON.stringify(feedSettings))
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

    Item {
        anchors.centerIn: parent
        width: parent.width - 20
        height: parent.height - 30

        RssTabBar {
            id: rssBar
        }

        StackLayout {
            width: parent.width
            currentIndex: rssBar.currentIndex
            Repeater {
                id: feedsContent
                Item {
                    // id: modelData.keys()[0]
                    Text {
                        text: modelData
                    }
                }
            }
        }
    }



}