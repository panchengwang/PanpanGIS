// import QtQuick
// import QtQuick.Controls.Basic
// import QtQuick.Layouts
// import cn.pc.gis.control


// Button {
//     id: control

//     property int iconSize : PanStyles.default_icon_size
//     property string iconType: "material" // gis 或 material
//     property bool rounded: false

//     hoverEnabled: true
//     font.pixelSize: PanStyles.default_font_size
//     clip: true


//     implicitWidth:  PanStyles.button_implicit_width
//     implicitHeight: PanStyles.button_implicit_height
//     activeFocusOnTab: true
//     // padding: PanStyles.default_padding
//     contentItem: RowLayout{
//         anchors.centerIn: parent
//         height: parent.height
//         anchors.margins: 0

//         Item{
//             Layout.fillWidth: true
//             visible: control.text.trim() !== ""
//         }

//         PanLabel{
//             id: fontIcon
//             text: icon.name
//             visible: icon.name.trim() !== ""
//             font.family: iconType.trim() === "gis" ? PanFonts.gis.name : (
//                                                          iconType.trim() === "material" ? PanFonts.material.name : ""
//                                                          )
//             font.pixelSize: iconSize
//             color: control.focus || control.hovered ? PanStyles.color_button_text_activate : PanStyles.color_button_text
//             Layout.fillHeight: true
//             horizontalAlignment: control.text.trim() === "" ? Text.AlignLeft : Text.AlignHCenter
//             verticalAlignment: Text.AlignVCenter
//             // font.pixelSize: iconType.trim() === "material" ? PanStyles.default_font_size * 1.5 : PanStyles.default_font_size
//             Layout.leftMargin: control.text.trim() === "" ? -1 : 0
//         }

//         PanLabel {
//             Layout.fillHeight: true
//             // Layout.fillWidth: true
//             text: control.text
//             font: control.font

//             opacity: enabled ? 1.0 : 0.3
//             color: control.focus || control.hovered ? PanStyles.color_button_text_activate : PanStyles.color_button_text
//             horizontalAlignment: Text.AlignHCenter
//             verticalAlignment: Text.AlignVCenter
//             elide: Text.ElideRight
//             visible: control.text.trim() !== ""
//         }
//         Item{
//             Layout.fillWidth: true
//             visible: control.text.trim() !== ""
//         }
//     }



//     background: Rectangle{
//         color: control.focus || control.hovered ? PanStyles.color_button_activate : PanStyles.color_button
//         radius: rounded ? Math.min(control.width, control.height)*0.5 : PanStyles.default_radius
//         border.color: PanStyles.color_button_border
//         border.width: flat ? 0 : 1
//         opacity: flat && !control.hovered ? 0 : 1

//     }
// }

import QtQuick
import QtQuick.Layouts
import cn.pc.gis.control

Rectangle {
    id: button

    property string icon: PanAwesomeIcons.fa_check_circle
    property int iconSize: PanStyles.default_icon_size
    property string iconFontName: PanFonts.awesomeRegular.name
    property int textFontSize: PanStyles.default_font_size
    property string text: ""
    property bool flat: false
    property bool imageIcon: false
    property bool hovered: false
    property string direction: "LeftToRight"    // or UpToBottom

    property real leftPadding: PanStyles.default_padding
    property real rightPadding: PanStyles.default_padding
    property real topPadding: PanStyles.default_padding
    property real bottomPadding: PanStyles.default_padding


    property int _implicitHeight: direction === "TopToBottom" ?
                                      button.topPadding + button.bottomPadding +
                                      ( (image.visible || btnIcon.visible) && btnLabel.visible ? grid.rowSpacing : 0)
                                      + (image.visible ? image.height : 0)
                                      + (btnIcon.visible? btnIcon.height:0)
                                      + (btnLabel.visible? btnLabel.height : 0)
                                    :
                                      button.topPadding + button.bottomPadding + Math.max(btnIcon.height, btnLabel.height, image.height)
    property int _implicitWidth: direction === "LeftToRight" ?
                                     button.leftPadding + button.rightPadding
                                     + ((image.visible || btnIcon.visible) && btnLabel.visible ? grid.columnSpacing : 0)
                                     + (image.visible ? image.height : 0)
                                     + (btnIcon.visible ? btnIcon.width : 0)
                                     + (btnLabel.visible ?  btnLabel.width : 0)
                                   :
                                     button.leftPadding + button.rightPadding + Math.max(btnIcon.width, btnLabel.width, image.width)
    signal clicked()

    border.width: flat ? 0 : 1
    border.color: PanStyles.color_button_border
    radius: PanStyles.default_radius
    implicitHeight: text.trim() === "" ? Math.max(_implicitHeight,_implicitWidth) : _implicitHeight
    implicitWidth: text.trim() === "" ? Math.max(_implicitHeight, _implicitWidth) : _implicitWidth

    GridLayout{
        id: grid
        // clip: true

        anchors.leftMargin: button.leftPadding
        anchors.rightMargin: button.rightPadding
        anchors.topMargin: button.topPadding
        anchors.bottomMargin: button.bottomPadding
        anchors.centerIn: parent
        rows: direction === "LeftToRight" ? 1 : 999
        columns: direction === "TopToBottom" ?  1 : 999

        Image{
            id: image
            source: imageIcon ? icon : ""
            sourceSize{
                width: iconSize
                height: iconSize
            }
            fillMode: Image.PreserveAspectFit
            visible: imageIcon && icon.trim()!== ""
            horizontalAlignment: Text.AlignHCenter
        }

        PanLabel{
            id: btnIcon
            text: button.icon
            padding: 0
            font.family: iconFontName
            font.pixelSize: iconSize
            Layout.fillWidth: direction === "TopToBottom"
            horizontalAlignment: Text.AlignHCenter
            visible: icon.trim() !== "" && !imageIcon
        }

        PanLabel{
            id: btnLabel
            text: button.text
            Layout.fillWidth: direction === "TopToBottom"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: textFontSize
            visible: text.trim() !== ""
        }
    }

    MouseArea{
        id: mouse
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            button.clicked()
        }

        onEntered: {
            button.color = PanStyles.color_button_activate
            button.hovered = true
        }

        onExited: {
            setBackgroundColor()
            button.hovered = false
        }


    }

    Component.onCompleted: {
        setBackgroundColor()
    }

    function setBackgroundColor(){
        if(flat && button.parent){
            let p = button.parent
            while(p && !p.color){
                p = p.parent
            }
            if(p){
                button.color = p.color
            }else{
                button.color = PanStyles.color_button
            }
        }else{

            button.color = PanStyles.color_button
        }
    }

}
