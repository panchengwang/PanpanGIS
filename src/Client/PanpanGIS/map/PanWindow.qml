import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Popup {
    id: window

    property string caption : "Dialog"

    property int _originWindowX: 0
    property int _originWindowY: 0
    property int _originWindowWidth: 0
    property int _originWindowHeight: 0
    property bool _isWindowMaximum: false

    property int _minWidth: 100
    property int _minHeight: 100

    implicitWidth: 400
    implicitHeight: 300
    modal: true
    focus: true
    clip: true
    padding: 0
    closePolicy: modal ? Popup.NoAutoClose : Popup.CloseOnEscape

    background: Rectangle{
        anchors.fill: parent
        // anchors.centerIn: parent
        // width: parent.width
        // height: parent.height
        radius: PanStyles.default_radius
        color: "#FFFFFE"
    }



    ColumnLayout{
        // anchors.fill: parent
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        spacing: 0
        Rectangle{
            implicitHeight: PanStyles.header_implicit_height
            Layout.fillWidth: true
            color:  PanStyles.color_window_caption_background_activate
            radius: PanStyles.default_radius
            MouseArea{
                id: mouseArea
                anchors.fill: parent
                drag{
                    target: window.contentItem
                    axis: Drag.XandYAxis
                    smoothed: true
                }
                onPositionChanged: moveWindow()
                onDoubleClicked: {
                    if(_isWindowMaximum){
                        restoreWindow()
                    }else{
                        resizeToMaximum()
                    }
                }

                function moveWindow(){
                    let pos = mapToItem(window.parent,0,0)
                    window.x =Math.min(window.parent.width-window.width,  Math.max(0,pos.x))
                    window.y =Math.min(window.parent.height-window.height, Math.max(0,pos.y))
                    window.contentItem.x = 0
                    window.contentItem.y = 0
                }
            }
            RowLayout{
                anchors.fill: parent
                anchors.leftMargin: PanStyles.default_margin
                anchors.rightMargin: PanStyles.default_margin


                Item{
                    clip: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    PanLabel{
                        anchors.fill: parent
                        text: title
                    }
                }



                PanButton{
                    icon.name: PanMaterialIcons.md_window_minimize
                    flat: true
                    onClicked: window.visible = false
                }

                PanButton{
                    id: winMaxBtn
                    icon.name: PanMaterialIcons.md_window_maximize
                    flat: true
                    onClicked: resizeToMaximum()
                }

                PanButton{
                    id: winRestoreBtn
                    icon.name: PanMaterialIcons.md_window_restore
                    flat: true
                    visible: false
                    onClicked: restoreWindow()
                }

                PanButton{
                    icon.name: PanMaterialIcons.md_close
                    flat: true
                    onClicked: window.close()
                }
            }
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Flickable{
                anchors.fill: parent

            }

        }


        Rectangle{
            implicitHeight: PanStyles.header_implicit_height
            Layout.fillWidth: true
            color: "#E6E2F2"
            radius: 2
            clip: true
            RowLayout{
                anchors.fill: parent

                Item{
                    Layout.fillWidth: true
                }
                PanButton{
                    implicitWidth: 80
                    text: "取消"
                }


                PanButton{
                    implicitWidth: 80
                    text: "确定"
                    Layout.rightMargin: 5
                }

            }
        }
    }

    PanBorder{
        position: "left"
        target: window

    }

    PanBorder{
        position: "right"
        target: window
    }
    PanBorder{
        position: "top"
        target: window
    }
    PanBorder{
        position: "bottom"
        target: window
    }
    PanBorder{
        position: "left_top"
        target: window
    }
    PanBorder{
        position: "right_top"
        target: window
    }
    PanBorder{
        position: "left_bottom"
        target: window
    }
    PanBorder{
        position: "right_bottom"
        target: window
    }


    function resizeToMaximum(){
        _originWindowX = window.x
        _originWindowY = window.y
        _originWindowWidth = window.width
        _originWindowHeight = window.height

        window.x = 0
        window.y = 0;
        window.width = window.parent.width
        window.height = window.parent.height
        winMaxBtn.visible = false
        winRestoreBtn.visible = true
        _isWindowMaximum = true
    }

    function restoreWindow(){
        window.x = _originWindowX;
        window.y = _originWindowY;
        window.width = _originWindowWidth;
        window.height = _originWindowHeight;
        winMaxBtn.visible = true
        winRestoreBtn.visible = false
        _isWindowMaximum = false
    }
}
