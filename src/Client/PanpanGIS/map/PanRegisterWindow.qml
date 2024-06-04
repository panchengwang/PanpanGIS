import QtQuick
import QtQuick.Layouts
import cn.pc.gis.control

PanFormWindow {
    id: registerWin
    caption: "创建用户"
    windowButtonsVisible: true
    standardButtonsVisible: true

    property PanConnector connector:     PanConnector{
        onSuccess:{
            registerWin.close()
        }
        onFailure: {
            PanApplication.logWindow.open()
        }
    }

    width: 600
    height: 480

    PanLabel{
        anchors.topMargin: 10
        text: "EMail"
        horizontalAlignment:  Text.AlignLeft
        Layout.fillWidth: true
    }
    PanTextField{
        id: username
        type: "email"
        Layout.fillWidth: true
        placeholderText: "请使用一个有效的电子信箱地址作为用户名"
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
        id: identifyCode
        email: username.text.trim()
        server: PanApplication.masterUrl
        Layout.fillWidth: true
        onError: {
            PanApplication.notify.show(errorMessage)
        }
        onSuccess:{
            PanApplication.notify.show(errorMessage)
        }
    }


    onOk: onRegister()


    function onRegister(){

        if(username.text.trim() === ""){
            PanApplication.notify.show("邮箱（用户名）不能为空")
            return
        }

        if(password.text.trim() !== password2.text.trim()){
            PanApplication.notify.show("两次输入的密码不一致")
            return
        }

        if(identifyCode.code.trim()===""){
            PanApplication.notify.show("请输入验证码")
            return
        }

        if(identifyCode.code.trim().length !== 8){
            PanApplication.notify.show("请输入有效的验证码")
            return;
        }

        var req={
            type:"USER_REGISTER",
            data:{
                username: username.text.trim(),
                nickname: nickname.text.trim() === "" ? username.text.trim() : nickname.text.trim(),
                password: password.text.trim(),
                identify_code: identifyCode.code.trim()
            }
        }


        connector.post(PanApplication.masterUrl,"request",JSON.stringify(req))
    }

}
