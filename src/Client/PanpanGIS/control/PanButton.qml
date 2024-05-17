import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cn.pc.gis.control


Button {
    id: control


    property string iconType: "material" // gis 或 material
    property bool rounded: false

    hoverEnabled: true
    font.pixelSize: PanStyles.default_font_size
    clip: true


    implicitWidth:  PanStyles.button_implicit_width
    implicitHeight: PanStyles.button_implicit_height
    activeFocusOnTab: true
    // padding: PanStyles.default_padding
    contentItem: RowLayout{
        anchors.centerIn: parent
        anchors.margins: 0

        Item{
            Layout.fillWidth: true
            visible: control.text.trim() !== ""
        }

        PanLabel{
            id: fontIcon
            text: icon.name
            visible: icon.name.trim() !== ""
            font.family: iconType.trim() === "gis" ? PanFonts.gis.name : (
                                                         iconType.trim() === "material" ? PanFonts.material.name : ""
                                                         )
            font.pixelSize: PanStyles.default_icon_size
            color: control.focus || control.hovered ? PanStyles.color_button_text_activate : PanStyles.color_button_text
            Layout.fillHeight: true
            horizontalAlignment: control.text.trim() === "" ? Text.AlignLeft : Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            // font.pixelSize: iconType.trim() === "material" ? PanStyles.default_font_size * 1.5 : PanStyles.default_font_size
            Layout.leftMargin: control.text.trim() === "" ? -1 : 0
        }

        PanLabel {
            Layout.fillHeight: true
            // Layout.fillWidth: true
            text: control.text
            font: control.font

            opacity: enabled ? 1.0 : 0.3
            color: control.focus || control.hovered ? PanStyles.color_button_text_activate : PanStyles.color_button_text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            visible: control.text.trim() !== ""
        }
        Item{
            Layout.fillWidth: true
            visible: control.text.trim() !== ""
        }
    }



    background: Rectangle{
        color: control.focus || control.hovered ? PanStyles.color_button_activate : PanStyles.color_button
        radius: rounded ? Math.min(control.width, control.height)*0.5 : PanStyles.default_radius
        border.color: PanStyles.color_button_border
        border.width: flat ? 0 : 1
        opacity: flat && !control.hovered ? 0 : 1

    }
}
