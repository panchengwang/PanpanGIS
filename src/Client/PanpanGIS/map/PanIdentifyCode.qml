import QtQuick
import QtQuick.Layouts
import cn.pc.gis.control

RowLayout {
    property string email: ""
    property string serverUrl: ""
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
        }
    }
}
