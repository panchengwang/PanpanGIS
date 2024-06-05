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
        contentHeight: msgArea.height + 2 * PanStyles.default_margin
        TextArea{
            id: msgArea
            text: ""
            width:flick.width
            font.family: PanFonts.notoSansSimpleChineseRegular.name
            font.pixelSize: PanStyles.default_font_size
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }


    function show(message){
        msgArea.text = message
        open()
    }


    onOk: close()
    onCancel: close()
}
