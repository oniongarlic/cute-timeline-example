import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Timeline

Rectangle {
    id: timeLine
    property int pos: 1
    property Timeline tl;
    property int timeLineHeight: 16
    property int timeLineWidth: 20
    property int keyframes: 0

    property int currentFrame: 0
    
    color: "black"

    signal keyframeClicked(int key, Keyframe keyframe)
    
    Component.onCompleted: {
        
    }
    
    Binding on keyframes {
        delayed: true
        value: tl.endFrame
        when: tl.isReady
    }

    property KeyframeListView selectedTimeline;

    onSelectedTimelineChanged: console.debug(selectedTimeline===tl2)

    Flickable {
        id: timeLineContainer
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.horizontal: ScrollBar {
            policy: ScrollBar.AlwaysOn
        }
        // Layout.fillHeight: true
        width: parent.width
        contentWidth: cl.width
        contentHeight: cl.height
        flickableDirection: Flickable.HorizontalFlick
        height: cl.height+16
        clip: true
        WheelHandler {
            //onWheel: (event)=> console.log("rotation", event.angleDelta.y, "scaled", rotation, "@", point.position,"=>", parent.rotation)
            onWheel: (event)=>{timeLineContainer.flick(event.angleDelta.y*event.y, 0)}
        }

        ColumnLayout {
            id: cl
            width: tl.endFrame*timeLineWidth
            height: 2+10+1+(4*zoomHeightSlider.value)+32
            spacing: 1
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "blue"
            }
            ListView {
                id: tlFrame
                model: tl.endFrame
                Layout.preferredHeight: timeLineHeight
                Layout.fillWidth: true
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.StopAtBounds
                //interactive: false
                delegate: keyframeLabel
                header: timelineHeader
                headerPositioning: ListView.OverlayHeader
                property string headerText: "F"
                // header: Rectangle {
                //     height: 10
                //     width: 20
                //     color: "white"
                //     Label {
                //         anchors.centerIn: parent
                //         text: "F"
                //     }
                // }
                // headerPositioning: ListView.OverlayHeader
            }
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "blue"
            }
            KeyframeListView {
                id: tl1
                key: 0
                timeline: tl
                model: keyframes
                delegate: keyframeDelegate
                header: timelineHeader
                headerText: "X"
                selectedTimeline: timeLine.selectedTimeline===tl1
                Layout.preferredHeight: timeLineHeight
            }
            KeyframeListView {
                id: tl2
                key: 1
                timeline: tl
                model: keyframes
                delegate: keyframeDelegate
                header: timelineHeader
                headerText: "Y"
                selectedTimeline: timeLine.selectedTimeline===tl2
                Layout.preferredHeight: timeLineHeight
            }
            KeyframeListView {
                id: tl3
                key: 2
                timeline: tl
                model: keyframes
                delegate: keyframeDelegate
                header: timelineHeader
                headerText: "S"
                selectedTimeline: timeLine.selectedTimeline===tl3
                Layout.preferredHeight: timeLineHeight
            }
        }
    }

    Rectangle {
        x: timeLine.pos - timeLineContainer.contentX
        y: 0
        width: 3
        height: cl.height
        color: "red"
        border.color: "yellow"
    }

    Component {
        id: keyframeDelegate
        KeyframeDelegate {
            key: ListView.view.key
            width: timeLineWidth
            height: timeLineHeight
            keyframes: tl.index
            onKeyframe: keyframeClicked(key, keyframe)
        }
    }

    function setPosition(pos) {
        timeLine.pos = (1+pos)*timeLineWidth
    }

    Component {
        id: timelineHeader
        Label {
            id: tlh
            font.pixelSize: 10
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: timeLineWidth
            text: ListView.view.headerText
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    selectedTimeline=tlh.ListView.view
                }
            }
        }
    }

    Component {
        id: keyframeLabel
        Rectangle {
            id: fkl
            border.color: "grey"
            border.width: 1
            color: tl.currentFrameFixed==modelData ? "green" : "white"
            width: timeLineWidth
            height: timeLineHeight
            Label {
                text: modelData
                font.pixelSize: 8
                anchors.centerIn: parent
            }
            TapHandler {
                onTapped: {
                    setPosition(modelData);
                }
                onDoubleTapped: tl.currentFrame=modelData
            }
        }
    }

}

