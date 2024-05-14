import QtQuick
import QtQuick.Window
import cn.pc.gis.control
import cn.pc.gis.map

PanApplicationWindow {
    id: appWin
    width: Screen.width * 0.67
    height: Screen.height * 0.67

    visible: true
    title: qsTr("PanpanGIS")

    Component.onCompleted: {
        // if(appWin.token.trim() === ''){
        //     const loginPanel = Qt.createQmlObject(`
        //         import QtQuick
        //         import cn.pc.gis.control
        //         import cn.pc.gis.map
        //         PanLoginPanel{
        //             width: 500
        //             anchors.horizontalCenter: parent.horizontalCenter
        //             y: Math.max(50 , (parent.height - height)*0.5-50)
        //         }
        //         `,
        //         appWin,
        //         "loginPanel"
        //     );

        // }
    }

}
