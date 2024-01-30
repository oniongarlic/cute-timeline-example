import QtQuick
import QtQuick.Timeline
 import QtQuick.Controls

Rectangle {
    id: keyframeDelegate
    border.color: "grey"
    border.width: 1
    color: hasKeyframe(modelData) ? "white" : "darkgrey"
    width: 20
    height: zoomHeightSlider.value

    property var keyframes: []
    property int key;

    signal keyframe(int key, Keyframe keyframe)

    function hasKeyframe(i) {
        let k=keyframes[i]
        if (k==null) {
            console.debug("Keyframe data missing ?")
            return false;
        }
        if (k[key]==null)
            return false;

        return true
    }

    Label {
        anchors.centerIn: parent
        visible: hasKeyframe(modelData) && parent.height>20
        text: visible ? keyframes[modelData][key].value : ''
    }

    TapHandler {
        onSingleTapped: {
            console.debug(modelData)
            let k=keyframes[modelData]
            if (k==null) {
                console.debug("Keyframe data missing ?")
                return;
            }
            if (k[key]==null)
                return;

            console.debug("Keyframe Tap", k[key].frame, k[key].value)
            keyframeClicked(key, k[key])
        }
        onDoubleTapped: console.debug("taptap")
    }
}

