import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Control{
    property string okText: "确定"
    property string cancelText: "取消"
    property bool cancelVisible: true
    property bool okVisible: true
    signal ok()
    signal cancel()

    implicitWidth:  btnCancel.implicitWidth + btnOk.implicitWidth + row.spacing

    RowLayout {
        id: row
        anchors.fill: parent

        PanButton{
            id: btnCancel
            icon: PanAwesomeIcons.fa_times
            Layout.fillWidth: true
            text: cancelText
            visible: cancelVisible
            onClicked: {
                cancel()
            }
        }

        PanButton{
            id: btnOk
            Layout.fillWidth: true
            icon: PanAwesomeIcons.fa_check
            text: okText
            visible: okVisible
            onClicked: {
                ok()
            }
        }
    }
}


