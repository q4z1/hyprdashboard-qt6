pragma Singleton
import QtQuick 6.5

// import "../resources"

QtObject {
    readonly property QtObject palette: QtObject {
        readonly property QtObject secondary: QtObject {
            readonly property color col100: "#eff1f5"
            readonly property color col200: "#cdd3e0"
            readonly property color col300: "#a0acc4"
            readonly property color col400: "#7787a3"
            readonly property color col500: "#576378"
            readonly property color col600: "#394150"
            readonly property color col700: "#1d222b"
        }
    }

    readonly property QtObject iconFont: FontLoader {
        source: "../resources/hyprdash.ttf"
    }

    readonly property QtObject textFont: FontLoader {
        source: "../resources/cq_mono.otf"
    }

}
