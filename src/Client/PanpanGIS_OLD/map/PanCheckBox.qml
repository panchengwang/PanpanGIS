import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cn.pc.gis.control

CheckBox {
    id: control
    text: qsTr("CheckBox")
    checked: false

    indicator:Rectangle{
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        height: PanStyles.button_implicit_height - 2 * PanStyles.default_padding
        width: PanStyles.button_implicit_height - 2 * PanStyles.default_padding
        border.width: 1
        clip: true
        PanLabel{
            anchors.centerIn: parent
            text: control.checkState === Qt.Checked ? PanAwesomeIcons.fa_check : " "
            font.family: PanFonts.awesomeSolid.name
        }
    }
    contentItem:  PanLabel{
        Layout.alignment: Qt.AlignVCenter
        text: control.text
        leftPadding: control.indicator.width + control.spacing
    }
}
