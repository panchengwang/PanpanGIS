import QtQuick
import QtQuick.Layouts
import cn.pc.gis.control

RowLayout {
    PanTextField{
        Layout.fillWidth: true
        placeholderText: "输入验证码"
    }

    PanButton{
        text: "获取验证码"
    }
}
