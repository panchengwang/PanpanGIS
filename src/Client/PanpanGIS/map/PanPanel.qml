import QtQuick
import QtQuick.Layouts
 import QtQuick.Controls
import cn.pc.gis.control

Rectangle {
    id: panel

    property string title: "Panel"
    property Item contentItem: Rectangle{
        color: "red"
        anchors.fill: parent
    }

    implicitHeight: 300
    implicitWidth: 400
    border.width: 1
    // border.color: "#FF0000"
    border.color: PanStyles.color_primary

    radius: PanStyles.default_radius
    clip: true

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: panel.radius
        clip: true

        // PanHeader{
        //     Layout.fillWidth: true
        // }

        Rectangle{
            Layout.fillWidth: true
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

        Control{
            Layout.fillWidth: true
            Layout.fillHeight:  true
            contentItem: panel.contentItem

        }
    }



}
