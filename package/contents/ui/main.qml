 import QtQuick 1.1
 import org.kde.plasma.components 0.1 as PlasmaComponents
 import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: root

    property int minimumHeight: 400
    property int minimumWidth: 600
    property alias stationId: info.stationId

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', function() {
            stationId = plasmoid.readConfig("stationID");
        });
    }

    height: 500
    width: 700

    PlasmaCore.Theme{
        id: theme
    }

    TopPanel {
      id: info

      height: parent.height/8
      clip: true

      location: weatherData.status == XmlListModel.Ready ? weatherData.get(0).location : "Loading..."
      altitude: weatherData.status == XmlListModel.Ready ? weatherData.get(0).altitude : ""
      temp: weatherData.status == XmlListModel.Ready ? weatherData.get(0).tempF + "°F" : ""

        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            margins: 10
        }

    }

    PlasmaComponents.ToolButton {
        id: refresh

        anchors {
            bottom: parent.bottom
            left: parent.left
            margins: 5
        }

        height: updatedText.paintedHeight + 5
        iconSource: "view-refresh"
        onClicked: weatherData.reload()
    }

    Image {
        id: windImage

        anchors.centerIn: parent

        height: parent.height/3
        width: height
        fillMode: Image.Stretch

        source: "images/wind-white.png"
        rotation: weatherData.status == XmlListModel.Ready ? weatherData.get(0).windDeg : 0

        Behavior on rotation {
            PropertyAnimation {}
        }
    }

    Text {
        id: windDir

        anchors.centerIn: windImage

        text: weatherData.status == XmlListModel.Ready ? weatherData.get(0).windDir : "North"
        color: "#ffffff"

        font.pixelSize: windImage.height/6
    }

    Text {
        id: updatedText

        anchors {
            left: refresh.right
            bottom: parent.bottom
            margins: 5
        }

        text: weatherData.status == XmlListModel.Ready ? weatherData.get(0).time : ""
        color: "#ffffff"
    }

    Text {
        id: sourceInfo

        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 5
        }

        text: "<a href='http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID="+parent.stationId+"'>Weather data from Weather Underground</a>"

        color: "#ffffff"

        onLinkActivated: {
            Qt.openUrlExternally("http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID="+parent.stationId);
        }
    }

    XmlListModel {
        id: weatherData
        query: "/current_observation"
        source: "http://api.wunderground.com/weatherstation/WXCurrentObXML.asp?ID="+info.stationId

        //BASIC INFO ----------------
        XmlRole { name: "location"; query: "location/full/string()" }
        XmlRole { name: "altitude"; query: "location/elevation/string()" }
        XmlRole { name: "stationId"; query: "station_id/string()" }
        XmlRole { name: "time"; query: "observation_time/string()"; isKey: true }

        //WEATHER INFO --------------
        //Atmospheric Information
        XmlRole { name: "tempF"; query: "temp_f/number()"; isKey: true }
        XmlRole { name: "tempC"; query: "temp_c/number()"; isKey: true }
        XmlRole { name: "dewF"; query: "dewpoint_f/number()"; isKey: true }
        XmlRole { name: "dewC"; query: "dewpoint_c/number()"; isKey: true }
        XmlRole { name: "pressureInHg"; query: "pressure_in/number()"; isKey: true }
        XmlRole { name: "pressureMb"; query: "pressure_mb/number()"; isKey: true }

        //Wind
        XmlRole { name: "windDir"; query: "wind_dir/string()"; isKey: true }
        XmlRole { name: "windDeg"; query: "wind_degrees/number()"; isKey: true }
        XmlRole { name: "windSpeed"; query: "wind_mph/number()"; isKey: true }
        XmlRole { name: "windGust"; query: "wind_gust_mph/number()"; isKey: true }

        //Precipitation
        XmlRole { name: "rainHrIn"; query: "precip_1hr_in/number()" }
        XmlRole { name: "rainHrMm"; query: "precip_1hr_metric/number()" }
        XmlRole { name: "rainDayIn"; query: "precip_today_in/number()" }
        XmlRole { name: "rainDayCm"; query: "precip_today_metric/string()" }
    }
}
