import QtQuick
import QtQuick.Layouts
import cn.pc.gis.control

RowLayout {
    property string email: ""
    property string server: ""
    property string errorMessage: ""
    signal error()
    signal success()

    PanTextField{
        Layout.fillWidth: true
        placeholderText: "输入验证码"
    }

    PanButton{
        text: "获取验证码"
        onClicked: {
            if(email.trim() === "") {
                errorMessage = "需要设定接收验证码的邮箱地址"
                error();
                return;
            }
            if(server.trim() === ""){
                errorMessage = "需要设定提供验证码服务的url"
                error();
                return;
            }
            connector.post(server,"request",JSON.stringify({
                                                               "type":"USER_GET_IDENTIFY_CODE",
                                                               "username": email
                                                           }))
        }
    }

    PanConnector{
        id: connector
        onSuccess:{
            PanApplication.logWindow.appendLog(message,"information");
            PanApplication.logWindow.open()
        }
        onFailure: {
            PanApplication.logWindow.appendLog(message,"warning");
            PanApplication.logWindow.open()
        }
    }
}
