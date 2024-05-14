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
    activeFocusOnTab: true
    padding: PanStyles.default_padding
    contentItem: RowLayout{
        anchors.centerIn: parent
        anchors.margins: 0
        Item{
            Layout.fillWidth: true
        }

        PanLabel{
            id: fontIcon
            text: icon.name
            visible: icon.name.trim() !== ""
            font.family: iconType.trim() === "gis" ? PanFonts.gis.name : (
                                                         iconType.trim() === "material" ? PanFonts.material.name : ""
                                                         )
            font.pixelSize: PanStyles.default_icon_size
            color: control.focus ? PanStyles.color_button_text_activate : PanStyles.color_button_text
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            // font.pixelSize: iconType.trim() === "material" ? PanStyles.default_font_size * 1.5 : PanStyles.default_font_size
        }

        PanLabel {
            Layout.fillHeight: true
            // Layout.fillWidth: true
            text: control.text
            font: control.font

            opacity: enabled ? 1.0 : 0.3
            color: control.focus ? PanStyles.color_button_text_activate : PanStyles.color_button_text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            visible: control.text.trim() !== ""
        }
        Item{
            Layout.fillWidth: true
        }
    }



    background: Rectangle{
        implicitHeight: PanStyles.button_implicit_height
        implicitWidth: PanStyles.button_implicit_width
        color: control.focus ? PanStyles.color_button_activate : PanStyles.color_button
        // color: control.down || control.hovered ? PanStyles.color_secondary : PanStyles.color_primary
        // opacity: control.hovered ? 0.8 : 1.0
        radius: rounded ? Math.min(control.width, control.height)*0.5 : PanStyles.default_radius
        width: rounded ? Math.min(control.width,control.height) : control.width
        height: rounded ? Math.min(control.width,control.height) : control.height
        border.color: PanStyles.color_button_border
        border.width: 1

    }
}
