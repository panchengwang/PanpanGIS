import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

PanWindow {
    id: window

    caption: "空间数据管理"
    standardButtonsVisible: false


    ColumnLayout{
        anchors.fill: parent
        PanTextField{
            Layout.fillWidth: true
        }
    }
}
