import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

PanWindow {
    id: indicator
    implicitWidth: 400
    implicitHeight: 200

    maximizeButtonVisible: false
    minimizeButtonVisible: false

    background: Rectangle{
        anchors.fill: parent
        radius: PanStyles.default_radius
        color:  "#FFFFFE"
        border.width: 1
        border.color: PanStyles.color_button_border

    }
    Flickable{
        id: flick
        anchors.fill: parent
        anchors.margins: PanStyles.default_margin

        PanLabel{
            id: msgLabel
            text: ""
            width:flick.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }


    function show(message){
        msgLabel.text = message
        open()
    }


    onOk: close()
    onCancel: close()
}
