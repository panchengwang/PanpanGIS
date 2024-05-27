import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control


PanWindow{
    caption: "登录"
    standardButtonsVisible: true
    windowButtonsVisible: false
    width: 400
    height: 330
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
        // anchors.topMargin: 10
        text: "邮箱地址"
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
        // anchors.topMargin: 10
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
        text: "验证码"
    }
    PanIdentifyCode{
        Layout.fillWidth: true
    }

    RowLayout{
        Layout.fillWidth: true
        PanLabel{

            text: "如果您还没有注册？"
        }
        PanButton{
            icon: ""
            Layout.fillWidth: true
            text: "请单击这里注册新账号"
            flat: true
            onClicked: {
                createRegisterWindow()
            }
        }
    }

    function createRegisterWindow(){
        const registerWin = Qt.createQmlObject(`
            import QtQuick
            import cn.pc.gis.control
            import cn.pc.gis.map
            PanRegisterWindow{
                x: (parent.width-width)*0.5
                y: Math.max(100 , (parent.height - height)*0.5-100)
                width: Math.max(400,parent.width*0.5)
                visible: true
            }
            `,
            parent,
            "registerWin"
        );
        // loginPanel.visible = false
        registerWin.modal = true
        registerWin.cancel.connect(()=>{
                                       registerWin.destroy()

                                   })
        // createAccountPanel.cancel.connect(()=>{
        //                                       createAccountPanel.destroy()
        //                                       loginPanel.visible = true
        //                                   })
    }
}
