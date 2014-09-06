import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents

PlasmaCore.FrameSvgItem {
    id: topPanel

    property alias location: locationText.text
    property string conditions
    property string stationId
    property string altitude
    property alias temp: tempText.text
    property bool busy

    property string lastTemp: "°F"

    property int minimumWidth: 700

    onTempChanged: lastTemp = temp

    imagePath: "widgets/frame"
    prefix: "plain"

    PlasmaCore.Theme {
        id: theme
    }

    Image {
        id: conditionsIcon
        visible: !parent.busy

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            margins: 5
        }

        height: parent.height
        width: height

        fillMode: Image.PreserveAspectFit
    }
    PlasmaComponents.BusyIndicator {
        id: busyIcon

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            margins: 5
        }
        running: parent.busy
        visible: parent.busy
    }

    Text {
        id: locationText

        anchors {
            top: parent.top
            left: conditionsIcon.right
            right: tempText.left
            bottom: altitudeText.visible ? parent.verticalCenter : parent.bottom
            margins: 5
            bottomMargin: altitudeText.visible ? -3 : 5
        }

        width: parent.width - (conditionsIcon.width+tempText.width)
        scale: (paintedWidth > width) ? (width/paintedWidth) : 1
        transformOrigin: Item.Left
        verticalAlignment: Text.AlignVCenter

        font.pixelSize: height
        color: theme.textColor
    }

    Text {
        id: altitudeText

        anchors {
            top: locationText.bottom
            left: conditionsIcon.right
            bottom: parent.bottom
            margins: 5
        }

        scale: locationText.scale
        transformOrigin: Item.Left
        visible: parent.height >= 42

        text: parent.stationId+", "+parent.altitude
        font.pixelSize: height
        color: theme.textColor
    }

    Text {
        id: tempText

        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            margins: 5
        }

        verticalAlignment: Text.AlignVCenter
        font.pixelSize: height
        color: theme.textColor
    }
}
