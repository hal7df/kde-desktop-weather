import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0 as Plasmoid
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: temp

    property real tempF
    property real tempC
    property real dewF
    property real dewC
    property bool metric: parent.metric

    property real lastTempF: 0
    property real lastTempC: 0
    property real lastDewF: 0
    property real lastDewC: 0

    onTempFChanged: lastTempF = tempF
    onTempCChanged: lastTempC = tempC
    onDewFChanged: lastDewF = dewF
    onDewCChanged: lastDewC = dewC

    clip: true

    Rectangle {
        id: thermometer

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            margins: 10
        }

        width: parent.width/3

        clip: true

        color: "#00000000"
        border { color: PlasmaCore.Theme.textColor; width: 2 }

        Rectangle {
            id: tempLevel

            anchors {
                left: parent.left
                bottom: parent.bottom
                right: parent.right
            }

            z: -2
            color: PlasmaCore.Theme.highlightColor

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

            color: PlasmaCore.Theme.textColor

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
            color: PlasmaCore.Theme.textColor
        }

        Text {
            id: dewReadout

            anchors.left: parent.left
            anchors.leftMargin: 5

            y: dewLevel.y-(0.5*paintedHeight)

            text: temp.metric ? "Dew: "+temp.dewC+" °C" : "Dew: "+temp.dewF+"°F"
            color: PlasmaCore.Theme.textColor

            opacity: Math.abs(tempReadout.y-y) > paintedHeight ? 1 : 0
            visible: opacity != 0 ? true : false

            Behavior on opacity {
                NumberAnimation {}
            }
        }

    }
}
