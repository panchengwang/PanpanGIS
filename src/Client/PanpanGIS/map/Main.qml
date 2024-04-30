import QtQuick
import QtQuick.Window
import cn.pc.gis.control
import cn.pc.gis.map

PanApplicationWindow {

    width: Screen.width * 0.67
    height: Screen.height * 0.67

    visible: true
    title: qsTr("PanpanGIS")

    // PanLoginPanel{
    //     anchors.fill: parent
    // }

    Component.onCompleted: {
        console.log(Screen.width, Screen.devicePixelRatio, Screen.pixelDensity)
    }

}
