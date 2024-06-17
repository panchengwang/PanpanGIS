import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

PanWindow {
    id: window

    caption: "空间数据管理"
    standardButtonsVisible: false


    SplitView{
        id: split
        anchors.fill: parent
        Rectangle{
            SplitView.preferredWidth: Math.max(200,split.width * 0.3)
        }

        Rectangle{

        }
    }
}
