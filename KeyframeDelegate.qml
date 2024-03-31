import QtQuick
import QtQuick.Timeline
import QtQuick.Controls

Rectangle {
    id: kfd
    border.color: "grey"
    border.width: 1
    color: hasKeyframe(modelData) ? "white" : "darkgrey"

    property var keyframes: []
    property int key;

    signal keyframe(int key, Keyframe keyframe)

    function hasKeyframe(i) {
        let k=keyframes[i]
        if (k==null) {
            console.debug("Keyframe data missing ?", i, k)
            return false;
        }
        if (i==0) {
            console.debug("First", k, k[key])
        }

        if (k[key]==null)
            return false;

        return true
    }

    Label {
        anchors.fill: parent
        fontSizeMode: Text.VerticalFit
        visible: hasKeyframe(modelData)
        text: visible ? keyframes[modelData][key].value : ''
        elide: Text.ElideRight
        font.pixelSize: 16
        minimumPixelSize: 8
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    TapHandler {
        onSingleTapped: {
            console.debug(modelData)
            let k=keyframes[modelData]
            if (k==null) {
                console.debug("Keyframe data missing ?")
                return;
            }
            if (k[key]==null) {
                keyframeClicked(key, null)
                return;
            }

            console.debug("Keyframe Tap", key, k[key].frame, k[key].value)
            keyframeClicked(key, k[key])
        }
        onDoubleTapped: console.debug("taptap")
    }
}

