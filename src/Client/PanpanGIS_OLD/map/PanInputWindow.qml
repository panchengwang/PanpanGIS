import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

PanFormWindow{
    id: window
    caption: "输入"
    standardButtonsVisible: true
    windowButtonsVisible: true
    minimizeButtonVisible: false
    maximizeButtonVisible: false
    cancelButtonVisible: false

    implicitWidth: 400
    implicitHeight: 150

    signal accepted(string data)

    property string prompt: "请输入："
    PanLabel{
        text: window.prompt
        horizontalAlignment:  Text.AlignLeft
        Layout.fillWidth: true
    }
    PanTextField{
        id: input
        type: "text"
        Layout.fillWidth: true
        placeholderText: ""
        text: ""
    }

    onOk: {
        if(input.text.trim() !== ""){
            window.accepted(input.text)
        }
    }
}
