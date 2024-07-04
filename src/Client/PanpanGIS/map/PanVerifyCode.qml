import QtQuick
import QtQuick.Layouts
import cn.pc.gis.control

RowLayout {
    property string email: ""
    property string server: ""
    property string errorMessage: ""
    property alias code: input.text
    signal error()
    signal success()

    PanTextField{
        id: input
        Layout.fillWidth: true
        placeholderText: "输入验证码"
    }

    PanButton{
        icon: ""
        text: "获取验证码"
        onClicked: {
            if(email.trim() === "") {
                PanApplication.notify.show("需要设定接收验证码的邮箱地址")
                return;
            }
            if(server.trim() === ""){
                PanApplication.notify.show("需要设定提供验证码服务的url")
                return;
            }


            connector.post(server,"request",JSON.stringify({
                                                               "type":"USER_GET_VERIFY_CODE",
                                                               "data": {
                                                                   "username": email.trim()
                                                               }
                                                           }))
        }
    }

    PanConnector{
        id: connector
        showBusyIndicator: true
        onSuccess:{
            PanApplication.notify.show(message)
        }
        onFailure: {
            PanApplication.notify.show(message)
        }
        // onRunningChanged:{
        //     if(running){
        //         PanApplication.busyIndicator.open()
        //     }else{
        //         PanApplication.busyIndicator.close()
        //     }
        // }
    }
}
