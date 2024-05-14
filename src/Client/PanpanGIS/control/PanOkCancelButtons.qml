import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

RowLayout {

    property string okText: "确定"
    property string cancelText: "取消"

    signal ok()
    signal cancel()

    PanButton{
        Layout.preferredWidth: parent.width * 0.5
        Layout.fillWidth: true
        icon.name: PanMaterialIcons.md_close_circle
        text: cancelText
        onClicked: {
            cancel()
        }
    }

    PanButton{
        Layout.preferredWidth: parent.width * 0.5
        Layout.fillWidth: true
        icon.name: PanMaterialIcons.md_check_circle
        text: okText
        onClicked: {
            ok()
        }
    }
}
