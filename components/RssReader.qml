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
            console.log("feeds", JSON.stringify(feeds))
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
        feedSettings = gSettings.getValue("rss")
        console.log(JSON.stringify(feedSettings))
    }

    Layout.preferredWidth: 305
    Layout.minimumHeight: 290
    Layout.alignment: Qt.AlignTop


}