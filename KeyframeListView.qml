import QtQuick 
import QtQuick.Layouts
import QtQuick.Timeline

ListView {
    id: tllv
    
    required property int key;
    required property Timeline timeline;
    
    Layout.fillWidth: true
    
    orientation: ListView.Horizontal
    boundsBehavior: Flickable.StopAtBounds
}
