import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control


PanFormWindow{
    id: window
    caption: "登录"
    standardButtonsVisible: true
    windowButtonsVisible: false
    width: 400
    height: 330

    signal error()

    property PanConnector connector:     PanConnector{
        showBusyIndicator: true
        onSuccess:(data)=>{
                      window.close();
                      PanApplication.token = data.token
                      PanApplication.nodeUrl = data.url
                      console.log(JSON.stringify(data))
                  }
        onFailure: {
            PanApplication.notify.show(message)
        }

    }

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

        text: "邮箱地址"
        horizontalAlignment:  Text.AlignLeft
        Layout.fillWidth: true
    }
    PanTextField{
        id: username
        type: "email"
        Layout.fillWidth: true
        placeholderText: "请输入电子信箱地址"
        text: "593723812@qq.com"
    }
    PanLabel{

        text: "密码"
        horizontalAlignment:  Text.AlignLeft
        Layout.fillWidth: true

    }
    PanTextField{
        id: password
        type: "password"
        Layout.fillWidth: true
        placeholderText: "请输入密码"
        text: "pcwang"
    }



    GridLayout{
        Layout.fillWidth: true
        columns: 2
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

        PanLabel{

            text: "忘记密码？"
        }
        PanButton{
            icon: ""
            Layout.fillWidth: true
            text: "请单击这里重置密码"
            flat: true
            onClicked: {
                var win = createResetWindow()
                win.caption = "密码找回"
            }
        }
    }

    function createResetWindow(){

        const resetWin = Qt.createQmlObject(`
                                               import QtQuick
                                               import cn.pc.gis.control
                                               import cn.pc.gis.map
                                               PanUserWindow{
                                                   x: (parent.width-width)*0.5
                                                   y: Math.max(100 , (parent.height - height)*0.5-100)
                                                   width: Math.max(400,parent.width*0.5)
                                                   visible: true
                                               }
                                               `,
                                               parent,
                                               "resetWin"
                                               );
        resetWin.operation = "reset"
        resetWin.modal = true
        resetWin.cancel.connect(()=>{
                                       registerWin.destroy()
                                   })
        return resetWin;
    }

    function createRegisterWindow(){

        const registerWin = Qt.createQmlObject(`
                                               import QtQuick
                                               import cn.pc.gis.control
                                               import cn.pc.gis.map
                                               PanUserWindow{
                                                   caption: "用户注册"
                                                   x: (parent.width-width)*0.5
                                                   y: Math.max(100 , (parent.height - height)*0.5-100)
                                                   width: Math.max(400,parent.width*0.5)
                                                   visible: true
                                               }
                                               `,
                                               parent,
                                               "registerWin"
                                               );

        registerWin.modal = true
        registerWin.cancel.connect(()=>{
                                       registerWin.destroy()
                                   })
        return registerWin;
    }

     onOk: {
        if(username.text.trim() === "" || password.text.trim() === ""){
            PanApplication.notify.show("用户名和密码均不能为空");
            return;
        }

        connector.post(PanApplication.masterUrl,"request",
                       JSON.stringify(
                           {
                               "type": "USER_LOGIN",
                               "data": {
                                   "username": username.text.trim(),
                                   "password": password.text.trim()
                               }
                           })
                       );
    }
}
