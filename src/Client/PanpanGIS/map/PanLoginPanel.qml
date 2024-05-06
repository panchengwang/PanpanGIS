import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import cn.pc.gis.control
// import QtQuick.Effects

Rectangle {


    width: 400
    height: 300

    color: "#f0f0f0" //PanStyles.color_panel_background
    radius: PanStyles.default_radius

    Rectangle{
        id: panel
        anchors.fill: parent
        anchors.margins: PanStyles.default_margin
        radius: PanStyles.default_radius
        ColumnLayout{
            spacing: PanStyles.default_spacing
            anchors.fill: parent
            anchors.margins:  PanStyles.default_margin
            PanLabel{
                text: "欢迎来到PanpanGIS世界"
                horizontalAlignment:  Text.AlignHCenter
                Layout.fillWidth: true
                font.pointSize: PanStyles.header_text_font_size
            }

            Rectangle{
                Layout.fillWidth: true
                height: 1
                color: PanStyles.color_light_grey
            }

            PanLabel{
                anchors.topMargin: 10
                text: "EMail"
                horizontalAlignment:  Text.AlignLeft
                Layout.fillWidth: true
            }
            PanTextField{
                id: username
                type: "邮箱地址"
                Layout.fillWidth: true
                placeholderText: "请输入电子信箱地址"
            }
            PanLabel{
                anchors.topMargin: 10
                text: "密码"
                horizontalAlignment:  Text.AlignLeft
                Layout.fillWidth: true
            }
            PanTextField{
                id: password
                type: "password"
                Layout.fillWidth: true
                placeholderText: "请输入密码"
            }

            Rectangle{
                Layout.fillWidth: true
                height: 1
                color: PanStyles.color_light_grey
            }

            PanButton{
                Layout.fillWidth: true
                text:"登录"
            }

            Item{
                Layout.fillHeight: true
            }
        }

    }


    // MultiEffect{
    //     source: panel
    //     anchors.fill: panel
    //     shadowEnabled: true
    //     paddingRect: Qt.rect(0,0,40,50)
    // }
}
