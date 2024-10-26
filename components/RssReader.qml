import QtQuick 6.5
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import "../components"
import "../config" as Config
import "../js/xml2json.js" as Xml2Json

Box {
    id: rssReaderBox

    property var rss
    Component.onCompleted: { 
        rss = gSettings.getValue("rss") 
        console.log("rss:", JSON.stringify(rss))
        for(let i=0; i<rss.length; i++){
            let keys = Object.keys(rss[i])
            // console.log("keys", JSON.stringify(keys))
            let doc = new XMLHttpRequest();
            doc.onreadystatechange = function () {
                if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

                } else if (doc.readyState == XMLHttpRequest.DONE) {
                    try {
                        let response = doc.responseText
                        let xml = Xml2Json.xml2json(response)
                        console.log("xml", JSON.stringify(xml))
                        // let el = xml.selectAll('//item')
                        // console.log("xml", JSON.stringify(el))
                    } catch (e) {
                        console.log("fetchRss error:", JSON.stringify(e))
                    }
                }
            }
            console.log("GET", rss[i][keys[0]])
            doc.open("GET", rss[i][keys[0]]);
            doc.send();
        }
    }

    Layout.preferredWidth: 305
    Layout.minimumHeight: 290
    Layout.alignment: Qt.AlignTop


}