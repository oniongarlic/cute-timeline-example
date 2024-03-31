import QtQuick 
import QtQuick.Layouts
import QtQuick.Timeline

ListView {
    id: tllv
    
    required property int key;
    required property Timeline timeline;
    property string headerText: "-";

    property bool selectedTimeline;

    signal keyframeClicked(int key, Keyframe keyframe)
    
    Layout.fillWidth: true
    
    orientation: ListView.Horizontal
    boundsBehavior: Flickable.StopAtBounds

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: selectedTimeline ? "red" : "transparent"
        border.width: 1
    }

    onSelectedTimelineChanged: {
        console.debug(headerText,selectedTimeline)
    }
}
