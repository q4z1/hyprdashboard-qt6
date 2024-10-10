import QtQuick 6.5
import QtQuick.Effects

import "../config" as Config

Item {

    property alias color: box.color
    property alias radius: box.radius

    Rectangle {
        id: box
        anchors.fill: parent
        color: Config.Settings.palette.accent.col600
        radius: 15
    }

    MultiEffect {
        source: box
        anchors.fill: box
        shadowBlur: 1.0
        shadowColor: Config.Settings.palette.accent.col700
        shadowEnabled: true
        shadowHorizontalOffset: 4
        shadowOpacity: 0.9
        shadowScale: 0.9
        shadowVerticalOffset: 4
    }
}


