import QtQuick 6.5
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import "../config" as Config
import "../components"

import "../js/helpers.js" as Helpers

Box {
    id: mailBox

    Component.onCompleted: { 
        mails = processor.checkMails()
        console.log("mails", JSON.stringify(mails))
    }

    Timer {
        interval: 120000; running: true; repeat: true;
            onTriggered: mails = processor.checkMails()
    }

    property var mails

    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    Layout.preferredWidth: 280
    Layout.minimumHeight: 320
 

}


