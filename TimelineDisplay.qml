import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Timeline

Rectangle {
    id: timeLine
    property int pos: 1
    property Timeline tl;

    color: "black"

    signal keyframeClicked(int key, Keyframe keyframe)

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
            width: tl.endFrame*20
            height: 2+10+1+(4*zoomHeightSlider.value)+32
            spacing: 1
            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: "blue"
            }
            ListView {
                id: tlFrame
                model: tl.endFrame
                Layout.preferredHeight: 10
                Layout.fillWidth: true
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.StopAtBounds
                //interactive: false
                delegate: keyframeLabel
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
            ListView {
                id: tl1
                property int key: 0
                model: tl.endFrame
                Layout.preferredHeight: zoomHeightSlider.value
                Layout.fillWidth: true
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.StopAtBounds
                delegate: keyframeDelegate
            }
            ListView {
                id: tl2
                property int key: 1
                model: tl.endFrame
                Layout.preferredHeight: zoomHeightSlider.value
                Layout.fillWidth: true
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.StopAtBounds
                delegate: keyframeDelegate
            }
            ListView {
                id: tl3
                property int key: 2
                model: tl.endFrame
                Layout.preferredHeight: zoomHeightSlider.value
                Layout.fillWidth: true
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.StopAtBounds                
                delegate: keyframeDelegate
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
            keyframes: tl.index
            onKeyframe: keyframeClicked(key, keyframe)
        }
    }

    Component {
        id: keyframeLabel
        Rectangle {
            id: fkl
            border.color: "grey"
            border.width: 1
            color: tl.currentFrameFixed==modelData ? "green" : "white"
            width: 20
            height: 12
            Label {
                text: modelData
                font.pixelSize: 8
                anchors.centerIn: parent
            }
            TapHandler {
                onTapped: {
                    //timeLine.pos = eventPoint.position.x
                    timeLine.pos = 1+modelData*20
                    //fkl.ListView.view.currentIndex=modelData
                }
                onDoubleTapped: tl.currentFrame=modelData
            }
        }
    }

}

