import QtQuick 2.7
import QtMultimedia 5.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1


Item {
    Camera {
        id: camera1

        //imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        //flash.mode: Camera.FlashRedEyeReduction

        imageCapture {
            onImageCaptured: {
                photoPreview.source = photoPreviewCam1  // Show the preview in an Image
            }
            resolution: cbImageQ.currentText
            onResolutionChanged: {camera1.stop(); camera1.start();}
        }
    }

    Rectangle{
        id: one
        color: "white"
        width: parent.width
        height: parent.height
        border.color: "black"
        Text{
            id: videoRectangleLog
            text: "Camera 1"
            anchors.centerIn: parent
        }

        Item {
            width: parent.width
            height: parent.height
            Rectangle {

                anchors.fill: parent

                Flipable {
                    id: flipable
                    anchors.fill: parent

                    property bool flipped: false

                    front: Image { source: ""; anchors.centerIn: parent }
                    back: Image { source: ""; anchors.centerIn: parent }

                    transform: Rotation {
                        id: rotation
                        origin.x: flipable.width/2
                        origin.y: flipable.height/2
                        axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                        angle: 0    // the default angle
                    }

                    states: State {
                        name: "back"
                        PropertyChanges { target: rotation; angle: 180 }
                        when: flipable.flipped
                    }

                    transitions: Transition {
                        NumberAnimation { target: rotation; property: "angle"; duration: 200 }
                    }
                    VideoOutput {
                        id: cameraPreview1
                        anchors.fill: parent
                        fillMode: VideoOutput.PreserveAspectCrop
                        source: camera1

                    }
                }
                Rectangle{
                    id: cameralist1
                    anchors.fill: parent
                    visible: false
                    opacity: 0.5
                    color: "white"

                }
                ListView {
                    id: cameraModel
                    visible: cameralist1.visible
                    anchors.fill: parent
                    model: QtMultimedia.availableCameras

                    delegate: Text {
                        text: modelData.displayName
                        color: "red"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                camera1.deviceId = modelData.deviceId;
                                camera1.stop(); camera1.start();
                                cameralist1.visible = false;

                                cameraRes()

                                //console.info(camera1.imageCapture.supportedResolutions[0])
                                //cameraModel.model = QtMultimedia.availableCameras
                            }

                        }

                    }
                }

                Rectangle{
                    id: buttonListCam1
                    x: parent.width - 20

                    width: 20
                    height: 20

                    color: "red"
                    Text{
                        id: listcam
                        anchors.centerIn: parent
                        text: "1"

                    }
                    MouseArea{
                        id: buttonListCam1m
                        anchors.fill: parent
                        onClicked: {
                            cameraModel.model = QtMultimedia.availableCameras
                            if (cameralist1.visible == true)
                                cameralist1.visible = false
                            else
                                cameralist1.visible = true
                        }
                    }
                }

                Image{
                    width: 20
                    height: 20
                    x: mainWin.width - width
                    y: mainWin.height - width
                    //anchors.fill: parent
                    source: "opzioni.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {console.log("click"); opzioni.visible = true}
                    }


                }

                Rectangle{
                    id: opzioni
                    x: parent.width - width
                    y: parent.height - height
                    width: cbImageQ.width
                    height: mainWin.height

                    opacity: 0.5
                    visible: false

                }

                ComboBox {
                    id: cbImageQ
                    x: parent.width - width
                    y: parent.height - height - 100

                    textRole: "value"
                    currentIndex: 0

                    visible: opzioni.visible

                    model: ListModel {
                        id: modRes
                        //ListElement { key: "WAP - 640x360"; value: "160x120"; width: ""; height: ""}
                        /*ListElement { key: "Mobile - 640x480"; value: "640x480"; width: ""; height: ""}
                        ListElement { key: "HD - 1280x720"; value: "1280x720"; width: ""; height: "" }
                        ListElement { key: "UHD - 1920x1080"; value: "1920x1080"; width: ""; height: "" }
                        ListElement { key: "4K - 3840x2160"; value: "3840x2160"; width: ""; height: "" }
                        */
                    }

                    onActivated: {
                        camera1.imageCapture.resolution = cbImageQ.currentText
                        console.log("Resolution Changed: " + camera1.imageCapture.resolution)
                    }

                    Switch {
                        id: fullScreen
                        x: 0
                        y: 50
                        visible: opzioni.visible
                        text: qsTr("Fullscreen")
                        //display: AbstractButton.IconOnly
                        onPositionChanged: if(position ==1) {mainWin.showFullScreen()} else{ mainWin.showNormal()}

                    }

                    Switch {
                        id: mirror
                        x: 0
                        y: 80
                        visible: opzioni.visible
                        text: qsTr("Mirror")
                        //display: AbstractButton.IconOnly
                        onPositionChanged: flipable.flipped = !flipable.flipped
                    }

                }


                Rectangle{
                    x: parent.width - width
                    y: parent.height - height
                    //anchors.bottom: true
                    width: 25
                    height: 25
                    visible: opzioni.visible
                    Text{text: "X"; anchors.centerIn: parent}
                    MouseArea{
                        anchors.fill: parent
                        onClicked: opzioni.visible = false

                    }

                }

            }
        }


    }
    Component.onCompleted: {
        console.log("Supported resolution:")
        console.log(camera1.imageCapture.supportedResolutions)
        console.log("Resolution [5]:")
        camera1.imageCapture.resolution = camera1.imageCapture.supportedResolutions[camera1.imageCapture.supportedResolutions.length - 1]
        console.log(camera1.imageCapture.supportedResolutions[camera1.imageCapture.supportedResolutions.length - 1])
        console.log("Camera lock status:" + camera1.lockStatus)
        cameraRes()

    }

    Shortcut{sequence: "c" ; onActivated: cameralist1.visible = !cameralist1.visible}
    Shortcut{sequence: "o" ; onActivated: opzioni.visible = !opzioni.visible}
    Shortcut{sequence: "f" ; onActivated: fullScreen.position = !fullScreen.position}
    Shortcut{sequence: "m" ; onActivated: mirror.position = !mirror.position}
    Shortcut{sequence: "q" ; onActivated: Qt.quit()}

    function cameraRes (){
        console.info("Supported resolution")
        console.info(camera1.imageCapture.supportedResolutions)
        //console.info(camera1.imageCapture.supportedResolutions[0])

        //camera1.imageCapture.resolution = Qt.size(640, 480)
        console.info("Auto select resolution:")
        console.info(camera1.imageCapture.resolution)
        //camera1.imageCapture.resolution = camera1.imageCapture.supportedResolutions[camera1.imageCapture.supportedResolutions.length - 1]
        console.info("CAMARA RESOLUTION CHECK")
        modRes.clear()
        for (var i = 0; i < camera1.imageCapture.supportedResolutions.length; i++){
            var mwidth = camera1.imageCapture.supportedResolutions[i].width
            var mheight = camera1.imageCapture.supportedResolutions[i].height
            var str = mwidth + "x" + mheight
            modRes.append({"value": str})
        }
        cbImageQ.currentIndex = i - 1
    }
}
