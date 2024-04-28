import QtQuick
import QtQuick.Window
import cn.pc.gis.control
import cn.pc.gis.map

PanApplicationWindow {

    width: Screen.width * 0.67 * Screen.devicePixelRatio
    height: Screen.height * 0.67 * Screen.devicePixelRatio

    visible: true
    title: qsTr("PanpanGIS")

    PanLoginPanel{
        anchors.fill: parent
    }

}
