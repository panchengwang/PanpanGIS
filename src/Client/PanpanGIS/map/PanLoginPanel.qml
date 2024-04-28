import QtQuick
import QtQuick.Layouts
 import QtQuick.Controls
import cn.pc.gis.control


PanPanel {

    contentItem:GridLayout{
        anchors.fill: parent

        columns: 2

        PanLabel{
            text: "用户名"
        }

        PanTextField{
            Layout.fillWidth: true
        }

        PanLabel{
            text: "密码"
        }

        PanTextField{
            Layout.fillWidth: true
            placeholderText: "请在此输入密码"
            type: "password"
        }

        Item{
            Layout.fillHeight: true
            Layout.columnSpan: 2
        }
    }
}
