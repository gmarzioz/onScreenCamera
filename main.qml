import QtQuick 2.9
import QtQuick.Window 2.2
import QtMultimedia 5.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1



Window {
    id: mainWin
    visible: true
    height: 240
    width: 425
    minimumHeight: 240
    minimumWidth: 425
    title: qsTr("onScreenCamera")


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


                    VideoOutput {
                        id: cameraPreview1
                        anchors.fill: parent
                        fillMode: VideoOutput.PreserveAspectCrop
                        source: camera1

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
                                    cameralist1.visible = false;
                                    console.log(camera1.imageCapture.supportedResolutions)
                                    camera1.imageCapture.resolution = camera1.imageCapture.supportedResolutions[0]
                                    console.log(camera1.imageCapture.supportedResolutions[0])


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
                        currentIndex: 2

                        visible: opzioni.visible

                        model: ListModel {
                            id: modRes
                            ListElement { key: "WAP - 640x360"; value: "640x360"; width: ""; height: ""}
                            ListElement { key: "Mobile - 640x480"; value: "640x480"; width: ""; height: ""}
                            ListElement { key: "HD - 1280x720"; value: "1280x720"; width: ""; height: "" }
                            ListElement { key: "UHD - 1920x1080"; value: "1920x1080"; width: ""; height: "" }
                            ListElement { key: "4K - 3840x2160"; value: "3840x2160"; width: ""; height: "" }

                        }

                        onActivated: {
                            console.log("Resolution Changed...")
                            camera1.imageCapture.resolution = cbImageQ.currentText


                        }

                        Switch {
                            id: fullScreen
                            x: 0
                            y: 50
                            visible: opzioni.visible
                            text: qsTr("Fullscreen")
                            //display: AbstractButton.IconOnly
                            onClicked: if(position ==1) {mainWin.showFullScreen()} else{ mainWin.showNormal()}

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

}
