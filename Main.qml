import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Timeline

ApplicationWindow {
    width: 1024
    height: 480
    visible: true
    title: qsTr("Timelines test")        

    footer: ToolBar {
        RowLayout {
            Label {
                text: tl.currentFrameFixed
                Layout.preferredWidth: 4*12
            }
            CheckBox {
                id: lvEnabled
                text: "Enabled"
                checked: true
            }
            Slider {
                id: zoomHeightSlider
                from: 16
                to: 32
                value: 16
                stepSize: 1
                wheelEnabled: true
            }
            Slider {
                id: timeLineFrame
                from: 0
                to: tl.endFrame
                stepSize: 1
                onValueChanged: tl.currentFrame=value
                wheelEnabled: true
            }
            ToolButton {
                text: "Play"
                onClicked: {
                    ssAnimation.start()
                }
            }
            ToolButton {
                text: "Home"
                onClicked: timeLineContainer.contentX=0
            }
            ToolButton {
                text: "Clear"
                onClicked: {
                    tl.clear()

                }
            }
            ToolButton {
                text: "Dump"
                onClicked: {
                    dumpKeyframes(kfg1)
                    dumpKeyframes(kfg2)
                    dumpKeyframes(kfg3)
                }
            }
        }
    }

    property int fps: 30

    Rectangle {
        id: rect1
        width: 12
        height: 12
        radius: 6
        color: "red"
        z: 100
        visible: ssAnimation.running || timeLineFrame.value>0
    }

    function dumpKeyframes(k) {
        for (let i=0;i<k.keyframes.length;i++) {
            console.debug("***KEYFRAME: "+k.keyframes[i].frame+" : "+k.keyframes[i].value)
        }
    }

    Timeline {
        id: tl
        startFrame: 0
        endFrame: 60
        enabled: lvEnabled.checked

        property int currentFrameFixed: currentFrame

        property var index: []

        keyframeGroups: [
            KeyframeGroup {
                id: kfg1
                target: rect1
                property: "x"
                Keyframe { frame: 0; value: 1 }
                Keyframe { frame: 20; value: 100 }
                Keyframe { frame: 35; value: 200 }
                Keyframe { frame: 48; value: 300 }
                Keyframe { frame: 59; value: 320 }                
            },
            KeyframeGroup {
                id: kfg2
                target: rect1
                property: "y"
                Keyframe {frame: 0; value: 200 }
                Keyframe {frame: 20; value: 240 }
                Keyframe {frame: 30; value: 250 }
                Keyframe {frame: 40; value: 210 }
                Keyframe {frame: 59; value: 200 }
            },
            KeyframeGroup {
                id: kfg3
                target: rect1
                property: "radius"
                Keyframe {frame: 0; value: 6 }
                Keyframe {frame: 30; value: 0 }
                Keyframe {frame: 59; value: 6 }
            }
        ]

        function updateIndex(kfg, i) {
            kfg.keyframes.forEach(e => {
                                       console.log("Element: " + e.frame+" = "+e.value )
                                       index[e.frame][i]=e
                                   }
                                   )
        }

        function prepareIndex() {
            for (var i=0;i<endFrame;i++) {
                index[i]=[];
                index[i][0]=null;
                index[i][1]=null;
                index[i][2]=null;
            }
        }

        function updateIndexes() {
            prepareIndex();
            updateIndex(kfg1, 0);
            updateIndex(kfg2, 1);
            updateIndex(kfg3, 2);
        }

        function clear() {
            kfg1.keyframes=[]
            kfg2.keyframes=[]
            kfg3.keyframes=[]
            prepareIndex()
            updateIndex(kfg1, 0);
            updateIndex(kfg2, 1);
            updateIndex(kfg3, 2);
            tl.endFrame=0
            tl.endFrame=60
        }

        Component.onCompleted: {            
            updateIndexes();
            // index.forEach(e => { console.debug(e)} )
        }

        animations: [
            TimelineAnimation {
                id: ssAnimation
                duration: (tl.endFrame/fps)*1000
                easing.type: Easing.Linear
                from: tl.startFrame
                to: tl.endFrame
                onFinished: {
                    console.debug("Animation done")
                }
                onStarted: {
                    console.debug("Animation starts...")
                }
            }
        ]
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8
        TimelineDisplay {
            tl: tl
            Layout.fillWidth: true
            Layout.fillHeight: false

            onKeyframeClicked: {
                //kf.text=cu
                a.text=keyframe.value
            }
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2
            Label {
                id: kf
                text: "-"
                Layout.preferredWidth: 40
            }
            TextInput {
                id: a
                Layout.preferredWidth: 50
            }
            TextInput {
                id: b
                Layout.preferredWidth: 50
            }
            TextInput {
                id: c
                Layout.preferredWidth: 50
            }
            Button {
                text: "Update"
                onClicked: {

                }
            }
        }
    }
}
