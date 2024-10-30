import QtQuick 6.5
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import "../components"
import "../config" as Config
import "../js/xml2json.js" as Xml2Json

Box {
    id: rssReaderBox

    Connections {
        target: processor

        function onFeedsChanged() { 
            feeds = processor.getFeeds()
            console.log("feedsChanged", JSON.stringify(feeds))
        }
    }

    Timer {
        interval: 300000; running: true; repeat: true;
            onTriggered: processor.checkFeeds()
    }

    property var feeds
    Component.onCompleted: { 
        processor.checkFeeds()
    }

    Layout.preferredWidth: 305
    Layout.minimumHeight: 290
    Layout.alignment: Qt.AlignTop


}