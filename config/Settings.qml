pragma Singleton
import QtQuick 6.2

QtObject {
    readonly property QtObject palette: QtObject {
        readonly property QtObject color: QtObject {
            readonly property color col100: "#eb3f2f"
            readonly property color col200: "#eb8449"
            readonly property color col300: "#ebad27"
            readonly property color col400: "#aaac1c"
            readonly property color col500: "#77a86f"
            readonly property color col600: "#cfa9cd"
            readonly property color col700: "#57b6af"
            readonly property color col800: "#c8748c"
            readonly property color col900: "#cb4c7b"
        }

        readonly property QtObject accent: QtObject {
            readonly property color col100: "#eff1f5"
            readonly property color col200: "#cdd3e0"
            readonly property color col300: "#a0acc4"
            readonly property color col400: "#7787a3"
            readonly property color col500: "#576378"
            readonly property color col600: "#394150"
            readonly property color col700: "#1d222b"
        }
    }

    readonly property QtObject textFont: FontLoader {
        source: "../resources/cq_mono.otf"
    }

}
