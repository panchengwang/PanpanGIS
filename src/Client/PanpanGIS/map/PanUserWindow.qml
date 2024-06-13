import QtQuick
import QtQuick.Layouts
import cn.pc.gis.control

PanFormWindow {
    id: userWin
    caption: "创建用户"
    windowButtonsVisible: true
    standardButtonsVisible: true

    property string operation: "register"

    property PanConnector connector:     PanConnector{
        onSuccess:{
            userWin.close()
            PanApplication.notify.show(message)
        }
        onFailure: {
            PanApplication.notify.show(message)
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
        text: "593723812@qq.com"
        placeholderText: "请使用一个有效的电子信箱地址作为用户名"
    }

    PanLabel{
        text: "昵称"
        visible: operation !== "reset"
    }

    PanTextField{
        id: nickname
        type: "text"
        Layout.fillWidth: true
        placeholderText: "输入你喜欢的昵称"
        visible: operation !== "reset"
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
    PanVerifyCode{
        id: verifyCode
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


    onOk: {
        switch (operation){
        case "register":
            register();
            break;
        case "reset":
            reset();
            break;
        }
    }

    function checkUserInfo(){
        if(username.text.trim() === ""){
            PanApplication.notify.show("邮箱（用户名）不能为空")
            return false
        }

        if(password.text.length < 6 ){
            PanApplication.notify.show("密码应该为包含字母、数字和特殊符号、长度大于或等于6的字符串")
            return false
        }

        if(password.text.trim() !== password2.text.trim()){
            PanApplication.notify.show("两次输入的密码不一致")
            return false
        }

        if(verifyCode.code.trim().length !== 8){
            PanApplication.notify.show("请输入有效的验证码")
            return false
        }
        return true;
    }

    function register(){

        if(!checkUserInfo())    return;

        var req={
            type:"USER_REGISTER",
            data:{
                username: username.text.trim(),
                nickname: nickname.text.trim() === "" ? username.text.trim() : nickname.text.trim(),
                password: password.text.trim(),
                verify_code: verifyCode.code.trim()
            }
        }

        connector.success.connect(registerSuccess)
        connector.post(PanApplication.masterUrl,"request",JSON.stringify(req))
    }

    function registerSuccess (data){
        userWin.destroy()
    }

    function reset(){
        if(!checkUserInfo())    return;
        var req={
            type:"USER_RESET_PASSWORD",
            data:{
                username: username.text.trim(),
                password: password.text.trim(),
                verify_code: verifyCode.code.trim()
            }
        }

        connector.success.connect(()=>{userWin.destroy()})
        connector.post(PanApplication.masterUrl,"request",JSON.stringify(req))
    }
}
