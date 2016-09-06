import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.0

Item {
    id: pwsConfigRoot

    property alias cfg_stationID: stationID.text
    property alias cfg_refreshInterval: refreshInterval.value
    property alias cfg_metric: unitMetric.checked
    property alias cfg_stationOwner: stationOwner.checked

    Column {
        anchors.fill: parent;

        Layout.alignment: Qt.AlignLeft

        Button {
            id: findButton

            text: "Find a PWS"

            onClicked: Qt.openUrlExternally("https://www.wunderground.com/wundermap/&wxstn=1")
        }

        Item {
            id: contain_stationID

            anchors {
                top: findButton.bottom;
                topMargin: 10
            }

            height: stationID.height

            Label {
                id: label_stationID
                text: "Station ID"

                width: implicitWidth
                height: stationID.height
                verticalAlignment: Text.AlignVCenter
            }

            TextField {
                id: stationID

                anchors {
                    left: label_stationID.right;
                    leftMargin: 5
                }

                text: plasmoid.configuration.stationID
            }
        }

        Item {
            id: contain_refreshInterval

            anchors {
                top: contain_stationID.bottom
                topMargin: 5
            }

            height: refreshInterval.height

            Label {
                id:label_refreshInterval
                text: "Refresh Interval"

                width: implicitWidth
                height: refreshInterval.height
                verticalAlignment: Text.AlignVCenter
            }

            SpinBox {
                id: refreshInterval

                anchors {
                    left: label_refreshInterval.right
                    leftMargin: 5
                }

                minimumValue: 5
                maximumValue: 99

                suffix: " min"

                value: plasmoid.configuration.refreshInterval
            }
        }

        GroupBox {
            id: unitGroup

            anchors {
                top: contain_refreshInterval.bottom
                topMargin: 5
            }

            title: "Units"

            ExclusiveGroup {
                id: unitExcl
            }

            Column {
                spacing: 5

                RadioButton {
                    id: unitImperial
                    text: i18n("Imperial (US)")
                    checked: !plasmoid.configuration.metric
                    exclusiveGroup: unitExcl
                }

                RadioButton {
                    id: unitMetric
                    text: i18n("Metric")
                    checked: plasmoid.configuration.metric
                    exclusiveGroup: unitExcl
                }
            }
        }

        CheckBox {
            id: stationOwner

            anchors {
                top: unitGroup.bottom
                topMargin: 5
            }

            text: i18n("Station Owner Mode")

            checked: plasmoid.configuration.stationOwner
        }
    }
}
