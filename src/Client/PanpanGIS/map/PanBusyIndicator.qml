import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Popup {
    id: indicator
    implicitWidth: 100
    implicitHeight: 100


    background: Rectangle{
        anchors.fill: parent
        radius: PanStyles.default_radius
        color:  "#FFFFFE"
        border.width: 1
        border.color: PanStyles.color_button_border

    }

    ColumnLayout{
        anchors.fill: parent
        BusyIndicator{
            running: indicator.opened
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        PanLabel{
            text: "请等待..."
            Layout.alignment: Qt.AlignHCenter
        }
    }


}
