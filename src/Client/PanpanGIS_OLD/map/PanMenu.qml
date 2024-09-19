import QtQuick
import QtQuick.Controls
import cn.pc.gis.control

Menu{
    delegate: MenuItem{
        id: menuItem
        implicitHeight: PanStyles.button_implicit_height + topPadding
        contentItem: Text {
            leftPadding: menuItem.indicator.width
            rightPadding: menuItem.arrow.width
            text: menuItem.text
            font.family: PanFonts.notoSansSimpleChineseRegular.name
            font.pixelSize: PanStyles.default_font_size
            opacity: enabled ? 1.0 : 0.3
            color: menuItem.highlighted ? PanStyles.color_white : PanStyles.color_dark
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        background: Rectangle {
            anchors.fill: parent
            opacity: enabled ? 1 : 0.3
            color: menuItem.highlighted ? PanStyles.color_primary : "#EFEFEF"
        }
    }
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: PanStyles.button_implicit_height
        color: "#ffffffff"
        border.color: PanStyles.color_grey
        radius: PanStyles.default_radius
    }
}
