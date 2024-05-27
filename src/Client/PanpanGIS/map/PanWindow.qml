import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Popup {
    id: window

    property string caption : "Dialog"
    property bool standardButtonsVisible: false
    property bool windowButtonsVisible: true
    property Image image: null
    default property alias content: grid.children



    signal ok()
    signal cancel()

    property int _originWindowX: 0
    property int _originWindowY: 0
    property int _originWindowWidth: 0
    property int _originWindowHeight: 0
    property bool _isWindowMaximum: false

    property int _minWidth: 100
    property int _minHeight: 100

    implicitWidth: 400
    implicitHeight: 300
    modal: false
    focus: true
    clip: true
    padding: 0
    closePolicy: modal ? Popup.NoAutoClose : Popup.CloseOnEscape

    background: Rectangle{
        anchors.fill: parent
        // anchors.centerIn: parent
        // width: parent.width
        // height: parent.height
        radius: _isWindowMaximum ? 0 : PanStyles.default_radius
        color: "#FFFFFE"
    }



    ColumnLayout{
        // anchors.fill: parent
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        spacing: 0
        Rectangle{
            implicitHeight: PanStyles.window_header_footer_height
            Layout.fillWidth: true
            color:  PanStyles.color_window_caption_background_activate
            radius:  _isWindowMaximum ? 0 : PanStyles.default_radius
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

                Image{
                    Layout.fillHeight: true
                }

                Item{
                    clip: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    PanLabel{
                        anchors.fill: parent
                        font.pixelSize: PanStyles.default_font_size + 1
                        text: caption
                    }
                }



                PanButton{
                    icon: PanAwesomeIcons.fa_window_minimize
                    iconFontName: PanFonts.awesomeRegular.name
                    iconSize: PanStyles.default_icon_size - 2
                    implicitWidth: PanStyles.window_header_footer_height - PanStyles.default_margin
                    implicitHeight:PanStyles.window_header_footer_height - PanStyles.default_margin
                    flat: true
visible: windowButtonsVisible
                    onClicked: {
                        saveWindowStatus()
                        window.visible = false
                    }
                }

                PanButton{
                    id: winMaxBtn
                    icon: PanAwesomeIcons.fa_window_maximize
                    iconSize: PanStyles.default_icon_size - 2
                    implicitWidth: PanStyles.window_header_footer_height - PanStyles.default_margin
                    implicitHeight:PanStyles.window_header_footer_height - PanStyles.default_margin
                    flat: true
                    visible: windowButtonsVisible
                    onClicked: resizeToMaximum()
                }

                PanButton{
                    id: winRestoreBtn
                    icon: PanAwesomeIcons.fa_window_restore
                    iconSize: PanStyles.default_icon_size - 2
                    implicitWidth: PanStyles.window_header_footer_height - PanStyles.default_margin
                    implicitHeight:PanStyles.window_header_footer_height - PanStyles.default_margin
                    flat: true
                    visible: false
                    onClicked: restoreWindow()
                }

                PanButton{
                    icon: PanAwesomeIcons.fa_times
                    iconFontName: PanFonts.awesomeSolid.name
                    flat: true
                    visible: windowButtonsVisible
                    implicitWidth: PanStyles.window_header_footer_height - PanStyles.default_margin
                    implicitHeight:PanStyles.window_header_footer_height - PanStyles.default_margin
                    onClicked: {
                        // window.close()
                        window.destroy()
                    }
                }
            }
        }

        Flickable{
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: contentItem.childrenRect.height
            clip: true
            leftMargin: PanStyles.default_margin
            rightMargin: PanStyles.default_margin
            topMargin: PanStyles.default_margin
            bottomMargin: PanStyles.default_margin

            GridLayout {
                id: grid
                columns: 1
                width: parent.width
            }
        }


        Rectangle{
            implicitHeight: PanStyles.window_header_footer_height
            Layout.fillWidth: true
            color: "#E6E2F2"
            radius: 2
            clip: true
            visible: standardButtonsVisible
            RowLayout{
                anchors.fill: parent

                Item{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                PanStandardButtons{
                    Layout.fillHeight: true
                    Layout.rightMargin: 5
                    implicitWidth:  200
                    // implicitWidth: 200
                    onCancel: {
                        window.cancel()
                    }
                }

                // PanButton{
                //     implicitWidth: 80
                //     text: "取消"
                //     onClicked: window.close()
                // }


                // PanButton{
                //     implicitWidth: 80
                //     text: "确定"
                //     Layout.rightMargin: 5
                //     onClicked:{
                //         window.ok()
                //         window.close()
                //     }
                // }

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


    function saveWindowStatus(){
        _originWindowX = window.x
        _originWindowY = window.y
        _originWindowWidth = window.width
        _originWindowHeight = window.height
    }

    function resizeToMaximum(){
        saveWindowStatus()

        window.x = 0
        window.y = 0;
        window.width = window.parent.width
        window.height = window.parent.height
        winMaxBtn.visible = false
        winRestoreBtn.visible = true
        _isWindowMaximum = true
    }

    function restoreWindow(){
        window.visible = true
        window.x = _originWindowX;
        window.y = _originWindowY;
        window.width = _originWindowWidth;
        window.height = _originWindowHeight;
        winMaxBtn.visible = true
        winRestoreBtn.visible = false
        _isWindowMaximum = false
    }
}
