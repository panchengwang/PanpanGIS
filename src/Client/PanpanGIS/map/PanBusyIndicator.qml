import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Popup {
    id: indicator
    implicitWidth: 100
    implicitHeight: layout.width

    // property alias message: labelMessage.text

    background: Rectangle{
        anchors.fill: parent
        radius: PanStyles.default_radius
        color:  "#FFFFFE"
        border.width: 1
        border.color: PanStyles.color_button_border

    }

    ColumnLayout{
        id: layout
        x:0
        y:0
        anchors.centerIn: parent
        width: Math.max(labelMessage.width, 100)
        BusyIndicator{
            running: indicator.opened
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        PanLabel{
            id: labelMessage
            text: "请等待..."
            Layout.alignment: Qt.AlignHCenter
        }
    }

    onOpened: {
        PanApplication.zIndexOfTopWin ++;
        z = PanApplication.zIndexOfTopWin;
    }

}
