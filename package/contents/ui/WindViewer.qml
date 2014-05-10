import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: wind

    property alias degrees: windImage.rotation
    property alias direction: windReadout.text
    property int speed
    property int gust
    property bool isMetric

    property string lastDir: "North"
    property int lastDeg: 0
    property int lastSpeed: 0
    property int lastGust: 0

    onDirectionChanged: lastDir = direction
    onDegreesChanged: lastDeg = degrees
    onSpeedChanged: lastSpeed = speed
    onGustChanged: lastGust = gust


    width: parent.width/3

    PlasmaCore.Theme {
        id: theme
    }

    Image {
        id: windImage

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 10
        }

        height: width
        fillMode: Image.Stretch

        source: "images/wind-white.png"

        Behavior on rotation {
            PropertyAnimation {}
        }
    }

    Text {
        id: windReadout

        anchors.centerIn: windImage

        font.pixelSize: windImage.height/6
        color: theme.textColor
    }

    Item {
        id: speedInfo

        anchors {
            left: parent.left
            right: parent.right
            top: windImage.bottom
            bottom: parent.bottom
            topMargin: windImage.height/6
            bottomMargin: 10
        }

        Rectangle {
            id: speedGauge

            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

            width: parent.width/2

            border.color: theme.textColor
            color: "#00000000"

            clip: true

            Rectangle {
                id: windSpeed

                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    left: parent.left
                }

                height: (wind.speed/20)*parent.height
                z: -2

                color: theme.highlightColor

                Behavior on height {
                    PropertyAnimation {}
                }
            }

            Rectangle {
                id: windGust

                anchors {
                    left: parent.left
                    right: parent.right
                }

                z: -1
                y: parent.height-((wind.gust/20)*parent.height)
                height: 2
                color: theme.textColor

                Behavior on y {
                    PropertyAnimation {}
                }
            }
        }

        Text {
            id: speedReadout

            text: wind.isMetric ? "Speed: "+wind.convertMetric(wind.speed)+" km/h" : "Speed: "+wind.speed+" mph"
            font.pointSize: 10
            color: theme.textColor

            anchors { left: speedGauge.right; leftMargin: 5 }
            y: wind.speed < 20 ? (parent.height-((wind.speed/20)*parent.height))-(paintedHeight/2) : 0

            Behavior on y {
                PropertyAnimation {}
            }
        }

        Text {
            id: gustReadout

            text: wind.isMetric && wind.gust < 20 ? "Gust: "+wind.convertMetric(wind.gust)+" km/h" : "Gust: "+wind.gust+" mph"
            font.pointSize: 10
            color: theme.textColor

            anchors { left: speedGauge.right; leftMargin: 5 }
            y: wind.gust < 20 ? (parent.height-((wind.gust/20)*parent.height))-(paintedHeight/2) : 0

            Behavior on y {
                PropertyAnimation {}
            }
        }
    }

    function convertMetric (mSpeed)
    {
        mSpeed *= 1.609344

        return mSpeed.toFixed(1);
    }
}
