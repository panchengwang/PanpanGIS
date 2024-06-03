import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Popup {
    id: progress
    implicitWidth: 400
    implicitHeight: 80

    background: Rectangle{
        anchors.fill: parent
        radius: PanStyles.default_radius
        color:  "#FFFFFE"
        border.width: 1
        border.color: PanStyles.color_button_border
    }
    ColumnLayout{
        anchors.fill: parent
        PanLabel{
            Layout.fillWidth: true
        }
        ProgressBar{
            Layout.fillWidth: true
            indeterminate: true
        }
    }
}
