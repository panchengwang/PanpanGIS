import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Control{
    property string okText: "确定"
    property string cancelText: "取消"
    signal ok()
    signal cancel()

    implicitWidth:  btnCancel.implicitWidth + btnOk.implicitWidth + row.spacing

    RowLayout {
        id: row
        anchors.fill: parent

        PanButton{
            id: btnCancel
            icon: PanAwesomeIcons.fa_times_circle
            Layout.fillWidth: true
            text: cancelText
            onClicked: {
                cancel()
            }
        }

        PanButton{
            id: btnOk
            Layout.fillWidth: true
            icon: PanAwesomeIcons.fa_check_circle
            text: okText
            onClicked: {
                ok()
            }
        }
    }
}


