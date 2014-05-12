import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: precip

    property real hrIn
    property real hrMm
    property real dayIn
    property string dayCm

    property real lastHrIn: 0
    property real lastHrMm: 0
    property real lastDayIn: 0
    property real lastDayCm: 0

    property bool metric: parent.metric

    onHrInChanged: lastHrIn = hrIn
    onHrMmChanged: lastHrMm = hrMm
    onDayInChanged: {
        if (dayIn < 0)
            dayIn = 0;

        lastDayIn = dayIn;
    }

    onDayCmChanged: {
        var numConvert;

        numConvert = parseFloat(dayCm);
        console.log("Raw cm retrieved: ",numConvert)

        if (numConvert < 0)
            numConvert = 0;

        _dayCm = numConvert;
        lastDayCm = _dayCm;
    }

    clip: true

    PlasmaCore.Theme {
        id: theme
    }

    Item {
        id: dataContainer

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            left: parent.left
            margins: 10
        }

        Rectangle {
            id: rainGauge

            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }

            width: precip.width/3

            color: "#00000000"
            border.color: theme.textColor

            clip: true

            Rectangle {
                id: rainHr

                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    left: parent.left
                }

                color: theme.highlightColor

                z: -2
                height: (precip.hrIn/2)*parent.height

                Behavior on height {
                    PropertyAnimation {}
                }
            }

            /*Rectangle {
                id: rainDay

                anchors {
                    left: parent.left
                    right: parent.right
                }

                color: theme.textColor

                height: 2
                y: parent.height - ((precip.dayIn/2)*parent.height)
                z: -1

                Behavior on y {
                    PropertyAnimation {}
                }
            }*/
        }

        Text {
            id: hrReadout

            anchors {
                right: rainGauge.left
                rightMargin: 5
            }

            color: theme.textColor

            text: precip.metric ? "Hour: "+precip.hrMm+" mm" : "Hour: "+precip.hrIn+" in"

            y: (parent.height-rainHr.height)-(0.5*paintedHeight)

            /*
            opacity: Math.abs(dayReadout.y-y) > paintedHeight ? 1 : 0
            visible: opacity != 0 ? true : false
            */
        }

        /*Text {
            id: dayReadout

            anchors {
                right: rainGauge.left
                rightMargin: 5
            }

            color: theme.textColor

            text: {
                if (precip.metric)
                {
                    if (precip._dayCm == 0.0)
                        return "No rain today";
                    else
                        return "Day: "+precip._dayCm+" cm";
                }
                else
                {
                    if (precip.dayIn == 0.0)
                        return "No rain today.";
                    else
                        return "Day: "+precip.dayIn+" in";
                }
            }

            y: rainDay.y-(0.5*paintedHeight)
        }*/
    }
}
