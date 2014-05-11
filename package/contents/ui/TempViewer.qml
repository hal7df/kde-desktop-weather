import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: temp

    property int tempF
    property int tempC
    property int dewF
    property int dewC
    property bool metric

    property int lastTempF: 0
    property int lastTempC: 0
    property int lastDewF: 0
    property int lastDewC: 0

    onTempFChanged: lastTempF = tempF
    onTempCChanged: lastTempC = tempC
    onDewFChanged: lastDewF = dewF
    onDewCChanged: lastDewC = dewC

    clip: true

    PlasmaCore.Theme {
        id: theme
    }

    Rectangle {
        id: thermometer

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            margins: 10
        }

        width: parent.width/3

        color: "#00000000"
        border.color: theme.textColor

        Rectangle {
            id: tempLevel

            anchors {
                left: parent.left
                bottom: parent.bottom
                right: parent.right
            }

            z: -2
            color: theme.highlightColor

            height: ((temp.tempF+20)/140)*parent.height

            Behavior on height {
                PropertyAnimation {}
            }
        }

        Rectangle {
            id: dewLevel

            anchors {
                left: parent.left
                right: parent.right
            }

            height: 2

            y: parent.height-(((temp.dewF+20)/140)*parent.height)
            z: -1

            color: theme.textColor

            Behavior on y {
                PropertyAnimation {}
            }
        }
    }

    Item {
        id: textContain

        anchors {
            left: thermometer.right
            bottom: thermometer.bottom
            top: thermometer.top
            right: parent.right
        }

        Text {
            id: tempReadout

            anchors.left: parent.left
            anchors.leftMargin: 5

            y: (parent.height-tempLevel.height)-(0.5*paintedHeight)

            text: temp.metric ? temp.tempC+" °C" : temp.tempF+"°F"
            color: theme.textColor

            Behavior on y {
                PropertyAnimation{}
            }
        }

        Text {
            id: dewReadout

            anchors.left: parent.left
            anchors.leftMargin: 5

            y: dewLevel.y-(0.5*paintedHeight)

            text: temp.metric ? "Dew: "+temp.dewC+" °C" : "Dew: "+temp.dewF+"°F"
            color: theme.textColor

            opacity: Math.abs(tempReadout.y-y) > paintedHeight ? 1 : 0
            visible: opacity != 0 ? true : false

            Behavior on opacity {
                NumberAnimation {}
            }

            Behavior on y {
                PropertyAnimation {}
            }
        }

    }
}
