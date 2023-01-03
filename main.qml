import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    id: mainWin
    visible: true
    height: 240
    width: 425
    minimumHeight: 240
    minimumWidth: 425
    title: qsTr("onScreenCamera")


    MyCam{
    anchors.fill: parent
    }

}
