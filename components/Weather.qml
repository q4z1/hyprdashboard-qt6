import QtQuick 6.5
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import "../config" as Config
import "../components"

import "../js/helpers.js" as Helpers

Box {
    id: weatherBox

    Component.onCompleted: { 
        api = gSettings.getValue("openWeather")
        Helpers.getWeather(api.apiUrl.replace("{lon}", api.lon)
            .replace("{lat}", api.lat)
            .replace("{apiKey}", api.apiKey)
            .replace("{units}", api.units)
            .replace("{lang}", api.lang)
        )
    }

    onWeatherChanged: {
        weatherIcon.source = "../resources/openweather/" + weather.weather[0].icon + ".svg"
        tempText.text = Math.round(weather.main.temp) + "°C"
        weatherDesc.text = weather.weather[0].description
        tempFeelsText.text = "feels: " + weather.main.feels_like + "°C"
        tempMinText.text = "min: " + weather.main.temp_min + "°C"
        tempMaxText.text = "max: " + weather.main.temp_max + "°C"
        pressureText.text = "AP: " + weather.main.pressure + "hPa"
        humidityText.text = "Humidity: " + weather.main.humidity + "%"
        windText.text = "Wind: " + weather.wind.speed + "m/s"
        sunRiseText.text = "Sunrise: "  + new Date(weather.sys.sunrise * 1000).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
        sunSetText.text = "Sunset: " + new Date(weather.sys.sunset * 1000).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
    }


    Timer {
        interval: 600000; running: true; repeat: true;
        onTriggered: Helpers.getWeather(api.apiUrl.replace("{lon}", api.lon)
            .replace("{lat}", api.lat)
            .replace("{apiKey}", api.apiKey)
            .replace("{units}", api.units)
            .replace("{lang}", api.lang)
        )
    }

    property var api
    property var weather

    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    Layout.preferredWidth: 280
    Layout.preferredHeight: 303
    
    ColumnLayout{
        id: weatherContent
        anchors.fill: parent
        anchors.margins: 16
        spacing: 0

        RowLayout{
            Layout.preferredWidth: parent.width - 32
            Layout.preferredHeight: 96
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            Item {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.preferredWidth: parent.width / 2
                Layout.preferredHeight: 96
                IconImage {
                    id: weatherIcon
                    anchors.centerIn: parent
                    color: Config.Settings.palette.color.col400
                    width: 96
                    height: 96
                }
            }

            Text {
                id: tempText
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.preferredWidth: parent.width / 2
                Layout.preferredHeight: 96
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Config.Settings.palette.color.col200
                font.family: Config.Settings.textFont.font.family
                font.pointSize: 34
            }
        }

        Text {
            id: weatherDesc
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredWidth: parent.width
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            color: Config.Settings.palette.color.col700
            font.family: Config.Settings.textFont.font.family
            font.pointSize: 18
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            Layout.preferredWidth: parent.width
            Layout.bottomMargin: 4

            ColumnLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.preferredWidth: parent.width / 2
                spacing: 4

                Text {
                    id: tempFeelsText
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: Config.Settings.palette.accent.col300
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 12
                }
                Text {
                    id: tempMinText
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: Config.Settings.palette.accent.col300
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 12
                }
                Text {
                    id: tempMaxText
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: Config.Settings.palette.accent.col300
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 12
                }
                Text {
                    id: windText
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: Config.Settings.palette.accent.col300
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 12
                }
            }

            ColumnLayout{
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                Layout.preferredWidth: parent.width / 2
                spacing: 4

                Text {
                    id: pressureText
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    color: Config.Settings.palette.accent.col300
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 12
                }
                Text {
                    id: humidityText
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    color: Config.Settings.palette.accent.col300
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 12
                }
                Text {
                    id: sunRiseText
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    color: Config.Settings.palette.accent.col300
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 12
                }
                Text {
                    id: sunSetText
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    color: Config.Settings.palette.accent.col300
                    font.family: Config.Settings.textFont.font.family
                    font.pointSize: 12
                }
            }
        }
    }

}


