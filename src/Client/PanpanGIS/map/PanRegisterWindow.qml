import QtQuick
import QtQuick.Layouts
import cn.pc.gis.control

PanFormWindow {
    caption: "创建用户"
    windowButtonsVisible: true
    standardButtonsVisible: true

    width: 600
    height: 480

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
        text: "昵称"
    }

    PanTextField{
        id: nickname
        type: "text"
        Layout.fillWidth: true
        placeholderText: "输入你喜欢的昵称"
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

}
