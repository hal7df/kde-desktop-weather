 import QtQuick 1.1
 import org.kde.plasma.components 0.1 as PlasmaComponents
 import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: root

    property int minimumHeight: 330
    property int minimumWidth: 500
    property alias stationId: info.stationId
    property bool metric: false
    property int refreshInterval: 5

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', function() {
            stationId = plasmoid.readConfig("stationID");
            metric = plasmoid.readConfig("useMetric");
            refreshInterval = plasmoid.readConfig("refreshInterval");
        });

        plasmoid.aspectRatioMode = plasmoid.IgnoreAspectRatio;
    }

    onRefreshIntervalChanged: console.log("New refresh interval:",refreshInterval)

    PlasmaCore.Theme{
        id: theme
    }

    TopPanel {
      id: info

      height: parent.height*(20/175)
      clip: true
      busy: weatherData.status != XmlListModel.Ready


      temp: {
          if (weatherData.status == XmlListModel.Ready)
          {
              if (root.metric)
                  return weatherData.get(0).tempC + "°C";
              else
                  return weatherData.get(0).tempF + "°F";
          }
          else
          {
              return lastTemp;
          }
      }

        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            margins: 10
        }

    }

    WindViewer {
        id: wind

        anchors {
            top: info.bottom
            bottom: refresh.top
            horizontalCenter: parent.horizontalCenter
        }

        direction: weatherData.status == XmlListModel.Ready ? weatherData.get(0).windDir : lastDir
        degrees: weatherData.status == XmlListModel.Ready ? weatherData.get(0).windDeg : lastDeg
        speed: weatherData.status == XmlListModel.Ready ? weatherData.get(0).windSpeed : lastSpeed
        gust: weatherData.status == XmlListModel.Ready ? weatherData.get(0).windGust : lastGust
    }

    TempViewer {
        id:  temperature

        anchors {
            top: info.bottom
            bottom: refresh.top
            left: parent.left
            right: wind.left
        }

        tempC: weatherData.status == XmlListModel.Ready ? weatherData.get(0).tempC : lastTempC
        tempF: weatherData.status == XmlListModel.Ready ? weatherData.get(0).tempF : lastTempF
        dewC: weatherData.status == XmlListModel.Ready ? weatherData.get(0).dewC : lastDewC
        dewF: weatherData.status == XmlListModel.Ready ? weatherData.get(0).dewF : lastDewF

    }

    PrecipViewer {
        id: precipitation

        anchors {
            top: info.bottom
            bottom: refresh.top
            left: wind.right
            right: parent.right
        }

        hrIn: weatherData.status == XmlListModel.Ready ? weatherData.get(0).rainHrIn : lastHrIn
        hrMm: weatherData.status == XmlListModel.Ready ? weatherData.get(0).rainHrMm : lastHrMm
        dayIn: weatherData.status == XmlListModel.Ready ? weatherData.get(0).rainDayIn : lastDayIn
        dayCm: weatherData.status == XmlListModel.Ready ? weatherData.get(0).rainDayCm : lastDayCm
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
        onClicked: {
            autoRefresh.restart();
            weatherData.reload();
        }
    }

    Text {
        id: updatedText

        anchors {
            left: refresh.right
            bottom: parent.bottom
            margins: 5
        }

        text: weatherData.status == XmlListModel.Ready ? weatherData.get(0).time : "Refreshing..."
        color: theme.textColor
    }

    Text {
        id: sourceInfo

        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 5
        }

        text: "<a href='http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID="+parent.stationId+"'>Weather data from Weather Underground</a>"

        color: theme.textColor

        onLinkActivated: {
            Qt.openUrlExternally("http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID="+parent.stationId);
        }
    }

    Timer {
        id: autoRefresh
        repeat: true
        interval: parent.refreshInterval*60000
        running: interval != 240000

        onTriggered: weatherData.reload()
    }

    XmlListModel {
        id: weatherData
        query: "/current_observation"
        source: "http://api.wunderground.com/weatherstation/WXCurrentObXML.asp?ID="+info.stationId

        onStatusChanged: {
            if (status == XmlListModel.Ready)
            {
                info.location = get(0).location
                info.altitude = get(0).altitude
            }
        }

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
