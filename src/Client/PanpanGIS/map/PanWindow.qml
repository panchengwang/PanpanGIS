import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Popup {
    id: window

    property string caption : "Window"
    property bool standardButtonsVisible: okButtonVisible | cancelButtonVisible
    property bool windowButtonsVisible: maximizeButtonVisible | minimizeButtonVisible | closeButtonVisible
    property bool cancelButtonVisible: true
    property bool okButtonVisible: true
    property bool maximizeButtonVisible: true
    property bool minimizeButtonVisible: true
    property bool closeButtonVisible: true
    property bool stickButtonVisible: false
    property bool sticked: false
    property bool autoHide: false
    property int hideAfterMilliseconds: 5000

    property string resizebar: "lrtb"
    property Image image: null
    // property bool resizable: resizebar.indexOf("l") < 0 && resizebar.indexOf("r")<0 && resizebar.indexOf("t")<0 && resizebar.indexOf("b")
    property bool movable: true
    default property alias content: container.contentItem

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
    clip: false
    padding: 0
    closePolicy: modal ? Popup.NoAutoClose : Popup.CloseOnEscape

    background: Rectangle{
        anchors.fill: parent
        // anchors.centerIn: parent
        // width: parent.width
        // height: parent.height
        radius: _isWindowMaximum ? 0 : PanStyles.default_radius
        color:  "#FFFFFE"
        border.width: 1
        border.color: PanStyles.color_button_border
    }



    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 1 //PanStyles.default_margin
        spacing: 0
        Rectangle{
            implicitHeight: PanStyles.window_header_footer_height
            Layout.fillWidth: true
            color:  PanStyles.color_window_caption_background_activate
            radius:  _isWindowMaximum ? 0 : PanStyles.default_radius
            MouseArea{
                id: mouseArea
                anchors.fill: parent
                enabled: movable
                drag{
                    target: window.contentItem
                    axis: Drag.XandYAxis
                    smoothed: true

                }
                onPositionChanged: moveWindow()
                onDoubleClicked: {
                    // if(!resizable){
                    //     return;
                    // }

                    if(_isWindowMaximum){
                        restoreWindow()
                    }else{
                        resizeToMaximum()
                    }
                }

                function moveWindow(){
                    if(!movable){
                        return;
                    }

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
                    icon: PanAwesomeIcons.fa_thumbtack
                    iconFontName: PanFonts.awesomeSolid.name
                    iconSize: PanStyles.default_icon_size - 2
                    implicitWidth: PanStyles.window_header_footer_height - PanStyles.default_margin
                    implicitHeight:PanStyles.window_header_footer_height - PanStyles.default_margin
                    flat: true
                    visible: stickButtonVisible
                    onClicked: {
                        sticked = !sticked
                        internal._updateTimer()
                    }
                }
                RowLayout{
                    visible: windowButtonsVisible

                    PanButton{
                        icon: PanAwesomeIcons.fa_window_minimize
                        iconFontName: PanFonts.awesomeRegular.name
                        iconSize: PanStyles.default_icon_size - 2
                        implicitWidth: PanStyles.window_header_footer_height - PanStyles.default_margin
                        implicitHeight:PanStyles.window_header_footer_height - PanStyles.default_margin
                        flat: true
                        visible: minimizeButtonVisible
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
                        visible: maximizeButtonVisible
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
                        visible: closeButtonVisible
                        implicitWidth: PanStyles.window_header_footer_height - PanStyles.default_margin
                        implicitHeight:PanStyles.window_header_footer_height - PanStyles.default_margin
                        onClicked: {
                            window.close()
                        }
                    }
                }
            }
        }

        Control{
            id: container
            Layout.fillWidth: true
            Layout.fillHeight: true

            Timer{
                id: timer
                interval: hideAfterMilliseconds
                onTriggered: {
                    window.close()
                }
            }
        }

        // Flickable{
        //     Layout.fillWidth: true
        //     Layout.fillHeight: true
        //     contentHeight: contentItem.childrenRect.height
        //     clip: true
        //     leftMargin: PanStyles.default_margin
        //     rightMargin: PanStyles.default_margin
        //     topMargin: PanStyles.default_margin
        //     bottomMargin: PanStyles.default_margin

        //     GridLayout {
        //         id: grid
        //         columns: 1
        //         width: parent.width
        //     }
        // }


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
                    cancelVisible: cancelButtonVisible
                    okVisible: okButtonVisible
                    onCancel: {
                        window.cancel()
                    }
                }

            }
        }
    }

    PanBorder{
        position: "left"
        target: window
        visible: resizebar.indexOf("l") >=0
    }

    PanBorder{
        position: "right"
        target: window
        visible: resizebar.indexOf("r") >= 0
    }
    PanBorder{
        position: "top"
        target: window
        visible: resizebar.indexOf("t") >= 0
    }
    PanBorder{
        position: "bottom"
        target: window
        visible: resizebar.indexOf("b") >=0
                color: "red"
    }
    PanBorder{
        position: "left_top"
        target: window
        visible: resizebar.indexOf("l") >=0 && resizebar.indexOf("t") >=0
    }
    PanBorder{
        position: "right_top"
        target: window
        visible: resizebar.indexOf("r") >=0 && resizebar.indexOf("t") >=0
    }
    PanBorder{
        position: "left_bottom"
        target: window
        visible: resizebar.indexOf("l") >=0 && resizebar.indexOf("b") >=0
    }
    PanBorder{
        position: "right_bottom"
        target: window
        visible: resizebar.indexOf("r") >=0 && resizebar.indexOf("b") >=0

    }

    onVisibleChanged: {
        internal._updateTimer()
    }

    QtObject{
        id: internal
        function _updateTimer(){
            if(sticked){
                timer.stop()
            }

            if (visible && !timer.running && autoHide && !sticked){
                timer.start()
            }

            if(!visible){
                timer.stop()
            }
        }
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
