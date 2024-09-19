import QtQuick
import QtQuick.Layouts
import cn.pc.gis.control


Rectangle{
    implicitHeight: PanStyles.header_implicit_height
    color: PanStyles.color_primary
    RowLayout{
        anchors.fill: parent
        PanLabel{
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.leftMargin: PanStyles.default_margin
            color: PanStyles.color_button_text
            text: panel.title
        }

        PanButton{
            icon.name: PanMaterialIcons.md_window_minimize
        }

        PanButton{
            icon.name: PanMaterialIcons.md_window_maximize
        }

        PanButton{
            icon.name: PanMaterialIcons.md_close
            Layout.rightMargin: PanStyles.default_margin
        }
    }
}
