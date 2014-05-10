import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore

PlasmaCore.FrameSvgItem {
    id: topPanel

    property alias location: locationText.text
    property string conditions
    property string stationId
    property string altitude
    property alias temp: tempText.text

    property int minimumWidth: 700

    imagePath: "widgets/frame"
    prefix: "plain"

    Image {
        id: conditionsIcon

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

    Text {
        id: locationText

        anchors {
            top: parent.top
            left: conditionsIcon.right
            bottom: parent.verticalCenter
            margins: 5
            bottomMargin: -3
        }

        font.pixelSize: height
        color: "#ffffff"
    }

    Text {
        id: altitudeText

        anchors {
            top: locationText.bottom
            left: conditionsIcon.right
            bottom: parent.bottom
            margins: 5
        }

        text: parent.stationId+", "+parent.altitude
        font.pixelSize: height
        color: "#ffffff"
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
        color: "#ffffff"
    }
}
