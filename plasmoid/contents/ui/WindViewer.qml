import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0 as Plasmoid
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import "../code/contrast.js" as ContrastUtils

Item {
    id: wind

    property alias degrees: windImage.rotation
    property string direction
    property real speed
    property real gust
    property bool metric: parent.metric
    property bool updateWarning

    property string lastDir: "North"
    property int lastDeg: 0
    property real lastSpeed: 0
    property real lastGust: 0

    onDirectionChanged: lastDir = direction
    onDegreesChanged: lastDeg = degrees
    onSpeedChanged: lastSpeed = speed
    onGustChanged: lastGust = gust


    width: parent.width/3

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

        source: "images/wind-"+ContrastUtils.getContrasting(PlasmaCore.Theme.backgroundColor)+".png"

        visible: opacity != 0
        opacity: wind.speed > 0 ? 1 : 0

        Behavior on rotation {
            RotationAnimation { direction: RotationAnimation.Shortest }
        }

        Behavior on opacity {
            NumberAnimation {}
        }
    }

    Text {
        id: windReadout

        anchors.centerIn: windImage

        text: windImage.visible ? parent.direction : "Calm"
        font.pixelSize: windImage.height/6
        color: PlasmaCore.Theme.textColor
    }

    Text {
        id: updateWarning

        anchors {
            top: windReadout.bottom
            topMargin: 5
            horizontalCenter: windReadout.horizontalCenter
        }

        text: "NO RECENT UPDATE."
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: windReadout.pixelSize/3
        font.bold: true
        color: "#ff0000"
        visible: parent.updateWarning
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

            width: parent.width/3

            border { color: PlasmaCore.Theme.textColor; width: 2 }
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

                color: PlasmaCore.Theme.highlightColor

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
                color: PlasmaCore.Theme.textColor

                Behavior on y {
                    PropertyAnimation {}
                }
            }
        }

        Text {
            id: speedReadout

            text: wind.metric ? "Speed: "+wind.convertMetric(wind.speed)+" km/h" : "Speed: "+wind.speed+" mph"
            color: PlasmaCore.Theme.textColor

            anchors { left: speedGauge.right; leftMargin: 5 }
            y: wind.speed < 20 ? (parent.height-windSpeed.height)-(paintedHeight/2) : 0
        }

        Text {
            id: gustReadout

            text: wind.metric && wind.gust < 20 ? "Gust: "+wind.convertMetric(wind.gust)+" km/h" : "Gust: "+wind.gust+" mph"
            color: PlasmaCore.Theme.textColor

            anchors { left: speedGauge.right; leftMargin: 5 }
            y: wind.gust < 20 ? (parent.height-((wind.gust/20)*parent.height))-(paintedHeight/2) : 0

            opacity: Math.abs(speedReadout.y-y) > paintedHeight ? 1 : 0
            visible: opacity == 1

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
