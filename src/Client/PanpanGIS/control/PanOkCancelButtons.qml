import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Rectangle{
    property string okText: "确定"
    property string cancelText: "取消"
    signal ok()
    signal cancel()


    RowLayout {

        anchors.fill: parent

        PanButton{
            id: btnCancel
            icon: PanAwesomeIcons.fa_times
            Layout.fillWidth: true
            text: cancelText
            onClicked: {
                cancel()
            }
        }

        PanButton{
            id: btnOk
            Layout.fillWidth: true
            icon: PanAwesomeIcons.fa_check
            text: okText
            onClicked: {
                ok()
            }
        }
    }
}


