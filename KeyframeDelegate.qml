import QtQuick
import QtQuick.Timeline
import QtQuick.Controls

Rectangle {
    id: kfd
    border.color: selected ? "green" : "grey"
    border.width: 1
    color: hasKeyframe(modelData) ? "white" : "darkgrey"

    property var keyframes: []
    property int key;
    property bool selected: false

    signal keyframeClicked(int key, int frame, variant keyframe)
    signal keyframeDouble(int key, int frame, variant keyframe)

    function hasKeyframe(i) {
        let k=keyframes[i]
        if (k==null) {
            console.debug("Keyframe data missing @", i)
            return false;
        }
        if (i==0) {
            console.debug("First", k, k[key])
        }

        if (k[key]==null) {
            return false;
        }

        console.debug(i, k, k[key])

        return true
    }

    function getKeyframe(key) {
        return keyframes[key];
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
        onSingleTapped: (event, button) => {
            console.debug("MD", modelData)
            if (hasKeyframe(modelData)) {
                                let k=keyframes[modelData]
                                console.debug("Keyframe@", modelData, key, k, k[key])
                                keyframeClicked(key, modelData, k)
                            } else {
                                keyframeClicked(key, modelData, null)
                            }
        }
        onDoubleTapped: {
            console.debug("taptap")
            let k=keyframes[modelData]
            keyframeDouble(key, modelData, k)
        }
    }
}

