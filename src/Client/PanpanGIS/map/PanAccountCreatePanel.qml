import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import cn.pc.gis.control
// import QtQuick.Effects

Rectangle {
    id: createAccountPanel

    width: 400
    height: panel.height + 2*PanStyles.default_margin

    color: PanStyles.color_panel_background
    radius: PanStyles.default_radius

    signal cancel()

    Rectangle{
        id: panel
        // anchors.fill: parent
        anchors.margins: PanStyles.default_margin
        anchors.centerIn: parent
        width: parent.width - 2 * PanStyles.default_margin
        radius: PanStyles.default_radius
        height: column.implicitHeight + 2* PanStyles.default_margin

        ColumnLayout{
            id: column
            spacing: PanStyles.default_spacing
            anchors.fill: parent
            anchors.margins:  PanStyles.default_margin
            PanLabel{
                text: "创建账户"
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
                text: "请使用一个有效的电子信箱地址作为用户名"
                horizontalAlignment:  Text.AlignLeft
                Layout.fillWidth: true
            }
            PanTextField{
                id: username
                type: "email"
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
            PanLabel{
                anchors.topMargin: 10
                text: "确认密码"
                horizontalAlignment:  Text.AlignLeft
                Layout.fillWidth: true
            }
            PanTextField{
                id: password2
                type: "password"
                Layout.fillWidth: true
                placeholderText: "请再输入一次密码"
            }
            PanLabel{
                text: "验证码"
            }
            PanIdentifyCode{
                Layout.fillWidth: true
            }
            Rectangle{
                Layout.fillWidth: true
                height: 1
                color: PanStyles.color_light_grey
            }

            PanOkCancelButtons{
                Layout.fillWidth: true
                okText: "创建用户"

                onOk:{
                    appWin.showMessage('',true)
                }

                onCancel:{
                    createAccountPanel.cancel()
                }
            }

            Item{
                Layout.fillHeight: true
            }
        }

    }


}
